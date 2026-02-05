# frozen_string_literal: true

require 'test_helper'

class UpdateOrderTest < Minitest::Test
  def test_delegates_request_to_order_endpoint_with_payload
    client = Minitest::Mock.new
    order_id = 1001
    order = { 'id' => order_id, 'order_items' => [] }
    response = { 'order' => order }
    client.expect(:put, response, ['orders/1001', { body: order }])

    result = OrderDesk::Requests::UpdateOrder.new(client).call(order_id: order_id, order: order)

    assert_equal response, result
    client.verify
  end
end
