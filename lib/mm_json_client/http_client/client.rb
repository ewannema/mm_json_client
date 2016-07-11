require 'net/http'

module MmJsonClient
  module HttpClient
    # A helper class to handle lower level HTTP calls for the API.
    class Client
      attr_reader :options

      def initialize(url, endpoint, options = {})
        @url = url
        @endpoint = endpoint
        @options = options
      end

      def post(data)
        new_http(URI(@url)).start do |http|
          req = Net::HTTP::Post.new(@endpoint)
          req.body = data
          configure_content_type(req)

          http.request(req)
        end
      end

      private

      def new_http(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        configure_https(http) if uri.scheme == 'https'
        configure_timeouts(http)
        http
      end

      def configure_content_type(req)
        req['Accept'] = 'application/json'
        req['Content-Type'] = 'application/json'
      end

      def configure_https(http)
        http.use_ssl = true
        http.verify_mode = if @options[:verify_ssl] == false
                             OpenSSL::SSL::VERIFY_NONE
                           else
                             OpenSSL::SSL::VERIFY_PEER
                           end
      end

      def configure_timeouts(http)
        http.open_timeout = @options[:open_timeout] if @options[:open_timeout]
        http.read_timeout = @options[:timeout] if @options[:timeout]
      end
    end
  end
end
