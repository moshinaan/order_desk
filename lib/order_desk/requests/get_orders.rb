# frozen_string_literal: true

require 'uri'

module OrderDesk
  module Requests
    class GetOrders < Base
      def call(params: nil)
        client.get(build_path(params))
      end

      private

      def build_path(params)
        return 'orders' if params.nil? || params.empty?

        query = URI.encode_www_form(params)
        "orders?#{query}"
      end
    end
  end
end
