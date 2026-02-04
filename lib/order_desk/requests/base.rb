# frozen_string_literal: true

module OrderDesk
  module Requests
    class Base
      def initialize(client)
        @client = client
      end

      private

      attr_reader :client
    end
  end
end
