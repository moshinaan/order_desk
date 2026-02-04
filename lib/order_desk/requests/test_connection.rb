# frozen_string_literal: true

module OrderDesk
  module Requests
    class TestConnection < Base
      def call
        client.get('test')
      end
    end
  end
end
