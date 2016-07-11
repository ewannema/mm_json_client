require 'json'

module MmJsonClient
  module JsonRpcHttp
    # A standard formatted JSON-RPC error.
    class Error
      attr_reader :code
      attr_reader :data
      attr_reader :message

      def initialize(data)
        @code = data['code']
        @data = data['data']
        @message = data['message']
      end
    end
  end
end
