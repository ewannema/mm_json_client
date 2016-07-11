module MmJsonClient
  # The server responded with an error.
  class ServerError < StandardError
    attr_reader :code
    attr_reader :message

    def initialize(code, message)
      @code = code
      @message = message
    end

    def message
      "code: #{@code} ; message: #{@message}"
    end

    def to_s
      message
    end
  end
end
