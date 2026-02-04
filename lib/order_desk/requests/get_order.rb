# frozen_string_literal: true

module OrderDesk
  module Requests
    class GetOrder < Base
      def call(order_id:)
        client.get("orders/#{order_id}")
      end
    end
  end
end
