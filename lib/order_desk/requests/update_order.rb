# frozen_string_literal: true

module OrderDesk
  module Requests
    class UpdateOrder < Base
      def call(order_id:, order:)
        client.put("orders/#{order_id}", body: order)
      end
    end
  end
end
