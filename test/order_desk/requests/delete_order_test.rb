# frozen_string_literal: true

require 'test_helper'

class DeleteOrderTest < Minitest::Test
  def test_delegates_request_to_order_endpoint
    client = Minitest::Mock.new
    order_id = 1001
    response = { 'message' => 'Order deleted' }
    client.expect(:delete, response, ['orders/1001'])

    result = OrderDesk::Requests::DeleteOrder.new(client).call(order_id: order_id)

    assert_equal response, result
    client.verify
  end
end
