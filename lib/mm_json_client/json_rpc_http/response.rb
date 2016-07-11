require 'json'
require 'mm_json_client/json_rpc_http/exceptions'
require 'mm_json_client/json_rpc_http/error'

module MmJsonClient
  module JsonRpcHttp
    # A standard formatted JSON-RPC response.
    class Response
      attr_reader :error
      attr_reader :id
      attr_reader :result
      attr_reader :version

      def initialize(json)
        data = JSON.parse(json)
        @version = data['version']
        @result = data['result']
        @error = data['error'] && new_error(data['error'])
        @id = data['id']
      rescue JSON::ParserError
        raise InvalidResponseFormat
      end

      private

      def new_error(error_data)
        MmJsonClient::JsonRpcHttp::Error.new(error_data)
      end
    end
  end
end
