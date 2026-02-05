# frozen_string_literal: true

require 'test_helper'

class GetOrdersTest < Minitest::Test
  def test_delegates_request_to_orders_endpoint_without_params
    client = Minitest::Mock.new
    response = { 'orders' => [{ 'id' => '1001' }] }
    client.expect(:get, response, ['orders'])

    result = OrderDesk::Requests::GetOrders.new(client).call(params: nil)

    assert_equal response, result
    client.verify
  end

  def test_delegates_request_to_orders_endpoint_with_query_params
    client = Minitest::Mock.new
    response = { 'orders' => [{ 'id' => '1001' }] }
    params = { 'since' => '2024-01-01', 'page' => 2 }
    client.expect(:get, response, ['orders?since=2024-01-01&page=2'])

    result = OrderDesk::Requests::GetOrders.new(client).call(params: params)

    assert_equal response, result
    client.verify
  end
end
