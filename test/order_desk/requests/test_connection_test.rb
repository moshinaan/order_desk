# frozen_string_literal: true

require 'test_helper'

class TestConnectionTest < Minitest::Test
  def test_delegates_request_to_test_endpoint
    client = Minitest::Mock.new
    response = { 'status' => 'success' }
    client.expect(:get, response, ['test'])

    result = OrderDesk::Requests::TestConnection.new(client).call

    assert_equal response, result
    client.verify
  end
end
