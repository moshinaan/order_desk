# frozen_string_literal: true

require 'test_helper'

class OrderDeskClientTest < Minitest::Test
  def setup
    super
    @store_id = 'store_123'
    @api_key = 'api_key_abc'
    @base_url = 'https://app.orderdesk.me/api/v2/'
    @client = OrderDesk::Client.new(store_id: @store_id, api_key: @api_key, base_url: @base_url)
  end

  def test_raises_authentication_error_on_401
    stub_request(:get, 'https://app.orderdesk.me/api/v2/test')
      .to_return(status: 401, body: { status: 'error' }.to_json)

    assert_raises(OrderDesk::AuthenticationError) { @client.test_connection }
  end

  def test_raises_rate_limit_error_with_retry_after
    stub_request(:get, 'https://app.orderdesk.me/api/v2/test')
      .to_return(status: 429, headers: { 'Retry-After' => '10' }, body: '')

    error = assert_raises(OrderDesk::RateLimitError) { @client.test_connection }
    assert_equal 10, error.retry_after
  end

  def test_update_order_returns_updated_order_payload
    request = Minitest::Mock.new
    order_id = 1001
    order = { 'id' => order_id, 'order_items' => [] }
    request.expect(:call, { 'order' => order }, [{ order_id: order_id, order: order }])

    OrderDesk::Requests::UpdateOrder.stub(:new, request) do
      assert_equal order, @client.update_order(order_id, order: order)
    end

    request.verify
  end
end
