# frozen_string_literal: true

module OrderDesk
  module Requests
    class DeleteOrder < Base
      def call(order_id:)
        client.delete("orders/#{order_id}")
      end
    end
  end
end
