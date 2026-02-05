# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'

module OrderDesk
  class Client
    DEFAULT_BASE_URL = 'https://app.orderdesk.me/api/v2'
    DEFAULT_TIMEOUT = 30
    DEFAULT_HEADERS = {
      'Accept' => 'application/json'
    }.freeze

    def initialize(store_id:, api_key:, base_url: DEFAULT_BASE_URL, timeout: DEFAULT_TIMEOUT)
      @store_id = store_id
      @api_key = api_key
      @base_url = normalized_base_url(base_url)
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

    # GET /orders
    def get_orders(params: nil)
      response = Requests::GetOrders.new(self).call(params: params)
      response['orders'] || response
    end

    # PUT /orders/:id
    def update_order(order_id, order:)
      response = Requests::UpdateOrder.new(self).call(order_id: order_id, order: order)
      response['order'] || response
    end

    def get(path)
      request(:get, path)
    end

    def put(path, body:)
      request(:put, path, body: body)
    end

    private

    def request(method, path, body: nil)
      uri = build_uri(path)
      response = build_http(uri).request(build_request(method, uri, body: body))
      handle_response(response)
    end

    def build_request(method, uri, body: nil)
      request_class = case method
                      when :get then Net::HTTP::Get
                      when :put then Net::HTTP::Put
                      else
                        raise ArgumentError, "Unsupported HTTP method: #{method}"
                      end

      request = request_class.new(uri)
      build_headers.each { |header, value| request[header] = value }
      attach_body(request, body) if body
      request
    end

    def build_headers
      DEFAULT_HEADERS.merge(
        'ORDERDESK-STORE-ID' => @store_id,
        'ORDERDESK-API-KEY' => @api_key
      )
    end

    def attach_body(request, body)
      request['Content-Type'] ||= 'application/json'
      request.body = JSON.generate(body)
    end

    def build_uri(path)
      URI.join(@base_url, path.to_s.sub(%r{^/}, ''))
    end

    def build_http(uri)
      Net::HTTP.new(uri.host, uri.port).tap do |http|
        http.use_ssl = uri.scheme == 'https'
        http.open_timeout = @timeout
        http.read_timeout = @timeout
      end
    end

    def handle_response(response)
      body = response.body.to_s
      parsed_body = parse_json(body)

      return parsed_body if response.code.to_i.between?(200, 299)

      handle_error(response.code.to_i, parsed_body || body, response)
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

    def normalized_base_url(url)
      url.end_with?('/') ? url : "#{url}/"
    end
  end
end
