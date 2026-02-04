# frozen_string_literal: true

module OrderDesk
  class Error < StandardError; end

  class ApiError < Error
    attr_reader :status, :body

    def initialize(message, status:, body: nil)
      super(message)
      @status = status
      @body = body
    end
  end

  class AuthenticationError < ApiError; end

  class RateLimitError < ApiError
    attr_reader :retry_after

    def initialize(message, status:, body: nil, retry_after: nil)
      super(message, status: status, body: body)
      @retry_after = retry_after
    end
  end
end
