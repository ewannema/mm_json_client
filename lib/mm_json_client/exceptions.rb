module MmJsonClient
  # The server responded with an error.
  class ServerError < StandardError
    attr_reader :code
    attr_reader :message

    def initialize(code, message)
      @code = code.to_i
      @message = message
    end

    def message
      "code: #{@code} ; message: #{@message}"
    end

    def to_s
      message
    end
  end

  # Could not connect to the server for what could be a transient reason.
  class ServerConnectionError < StandardError; end
end
