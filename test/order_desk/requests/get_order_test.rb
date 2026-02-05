# frozen_string_literal: true

require 'test_helper'

class GetOrderTest < Minitest::Test
  def test_delegates_request_to_order_endpoint
    client = Minitest::Mock.new
    order_id = 1001
    response = { 'order' => { 'id' => order_id.to_s } }
    client.expect(:get, response, ['orders/1001'])

    result = OrderDesk::Requests::GetOrder.new(client).call(order_id: order_id)

    assert_equal response, result
    client.verify
  end
end
