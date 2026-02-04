# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'

module OrderDesk
  class Client
    DEFAULT_BASE_URL = 'https://app.orderdesk.me/api/v2'

    ORDER_PROPERTIES = %w[
      id source_name source_id source_order_id source_order_number
      first_name last_name company_name email phone shipping_method
      shipping_first_name shipping_last_name shipping_company shipping_country
      shipping_state shipping_city shipping_postal shipping_address1 shipping_address2
      shipping_phone product_total shipping_total tax_total total currency_code
      customer_id customer_username customer_email customer_url customer_first_name
      customer_last_name customer_phone customer_company_name customer_notes
      customer_created customer_modified customer_balance customer_type
      customer_status customer_group source_updated date_added date_modified
      shipping_residential shipping_courier shipping_tracking_number
      shipping_tracking_url customer_organization vat_number tax_id
    ].freeze

    def initialize(store_id:, api_key:, base_url: DEFAULT_BASE_URL, timeout: 30)
      @store_id = store_id
      @api_key = api_key
      @base_url = base_url.end_with?('/') ? base_url : "#{base_url}/"
      @timeout = timeout
    end

    # GET /test
    def test_connection
      Requests::TestConnection.new(self).call
    end

    # GET /orders/:id
    def get_order(order_id)
      response = Requests::GetOrder.new(self).call(order_id: order_id)
      response['order'] || response
    end

    # Convenience helper that returns only known order property keys.
    def order_properties(order_id)
      order = get_order(order_id)
      order.each_with_object({}) do |(key, value), properties|
        properties[key] = value if ORDER_PROPERTIES.include?(key)
      end
    end

    def get(path)
      request(:get, path)
    end

    private

    def request(method, path)
      uri = URI.join(@base_url, path.to_s.sub(%r{^/}, ''))
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      http.open_timeout = @timeout
      http.read_timeout = @timeout

      request = build_request(method, uri)
      response = http.request(request)

      body = response.body.to_s
      parsed_body = parse_json(body)

      return parsed_body if response.code.to_i.between?(200, 299)

      handle_error(response.code.to_i, parsed_body || body, response)
    end

    def build_request(method, uri)
      request_class = case method
                      when :get then Net::HTTP::Get
                      else
                        raise ArgumentError, "Unsupported HTTP method: #{method}"
                      end

      request = request_class.new(uri)
      request['ORDERDESK-STORE-ID'] = @store_id
      request['ORDERDESK-API-KEY'] = @api_key
      request['Accept'] = 'application/json'
      request
    end

    def parse_json(body)
      return {} if body.nil? || body.strip.empty?

      JSON.parse(body)
    rescue JSON::ParserError
      nil
    end

    def handle_error(status, body, raw_response)
      case status
      when 401, 403
        raise AuthenticationError.new('Authentication failed', status: status, body: body)
      when 429
        retry_after = raw_response['Retry-After']&.to_i
        raise RateLimitError.new('Rate limit exceeded', status: status, body: body, retry_after: retry_after)
      else
        raise ApiError.new('Order Desk API request failed', status: status, body: body)
      end
    end
  end
end
