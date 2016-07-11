require 'json'
require 'mm_json_client/http_client/client'
require 'mm_json_client/json_rpc_http/response'

module MmJsonClient
  module JsonRpcHttp
    # A helper client for doing JSON-RPC calls over http.
    class Client
      def initialize(base_url, _endpoint, options = {})
        @http_client =
          MmJsonClient::HttpClient::Client.new(base_url,
                                               '/_mmwebext/mmwebext.dll?Soap',
                                               allowed_client_options(options))
      end

      # id defaults to false to detect if was specified. Null is a valid value
      # according to the spec.
      def request(method, params = nil, id = false)
        http_response = @http_client.post(request_message(method, params, id))
        MmJsonClient::JsonRpcHttp::Response.new(http_response.body)
      end

      private

      def base_request_message
        { jsonrpc: '2.0' }
      end

      def request_message(method, params, id)
        msg = base_request_message.merge(method: method, params: params)
        msg[:id] = id unless id == false # Optional
        msg.to_json
      end

      def allowed_client_options(options)
        allowed = [:verify_ssl, :open_timeout, :timeout]
        options.select { |option| allowed.include?(option) }
      end
    end
  end
end
