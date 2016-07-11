module MmJsonClient
  module JsonRpcHttp
    # The server responded with an invalid message format.
    class InvalidResponseFormat < StandardError
      def initialize(message = 'Server response format is invalid.')
        super(message)
      end
    end
  end
end
