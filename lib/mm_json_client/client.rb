require 'mm_json_client/exceptions'
require 'mm_json_client/json_rpc_http/client'
require 'mm_json_client/response_code'

module MmJsonClient
  # The entry point for using the API client.
  class Client
    attr_reader :connection

    def initialize(args = {})
      arg_errors = user_args_errors(args)
      raise ArgumentError, arg_errors.join(', ') unless arg_errors.empty?
      @options = calculate_options(args)
      @session_id = nil
    end

    def login
      @options[:proxy].each do |proxy|
        begin
          @rpc_client = JsonRpcHttp::Client.new(base_url(proxy, @options),
                                                @options)
          response = generic_request('Login', login_params, 'LoginResponse', false)
          @session_id = response.session
          return true
        rescue MmJsonClient::ServerError => e
          raise e unless e.code == MmJsonClient::ResponseCode::REQUESTS_DISABLED
        rescue SocketError, Net::OpenTimeout, Net::HTTPServerError
          # Keep trying the next server.
        end

      end

      if @session_id.nil?
        # We got here without a successful connection. Time to give up.
        raise MmJsonClient::ServerConnectionError,
          'Unable to connect to the proxy.'
      else
        true
      end
    end

    def logout
      return true if @session_id.nil?
      generic_request('Logout', {}, 'LogoutResponse')
      @session_id = nil
      true
    end

    # Recusively converts found MmJsonClient objects to hashes.
    def client_objects_to_h(value)
      case value.class.to_s
      when /^MmJsonClient/
        client_objects_to_h(value.to_h)
      when 'Hash'
        Hash[value.map { |k, v| [k, client_objects_to_h(v)] }]
      when 'Array'
        value.map { |v| client_objects_to_h(v) }
      else
        value
      end
    end

    private

    def login_params
      {
        login_name: @options[:username],
        password: @options[:password],
        server: @options[:server]
      }
    end

    def generic_request(method, arguments, response_type, authenticated = true)
      response = request(method, client_objects_to_h(arguments), authenticated)
      if response.error
        raise ServerError.new(response.error.code, response.error.message)
      end

      if response.result.class == Hash
        MmJsonClient::TypeFactory.build_from_data(
          response_type, response.result.mm_underscore_keys
        )
      else
        response.result
      end
    end

    def request(method, parameters = {}, authenticated = true)
      req_params = authenticated ? insert_session(parameters) : parameters
      @rpc_client.request(method, req_params.mm_camelize_keys)
    end

    def calculate_options(args)
      options = defaults.merge(args)
      # Default the proxy to the central server if not specified.
      options[:proxy] = options[:server] if options[:proxy].nil?
      options[:proxy] = [options[:proxy]] unless options[:proxy].class == Array
      options
    end

    def type_to_noun(type)
      type.to_s.split('::').last
    end

    class << self
      def define_api_method(method, return_type)
        ruby_method = method.mm_underscore
        class_eval do
          define_method(ruby_method) do |args = {}|
            unless args.class == Hash
              raise ArgumentError, 'argument must be a hash'
            end
            generic_request(method, args, return_type)
          end
        end
      end
    end

    def defaults
      {
        endpoint: '/_mmwebext/mmwebext.dll?Soap',
        ssl: false,
        verify_ssl: true,
        open_timeout: 10
      }
    end

    def insert_session(hash = {})
      hash.merge(session: @session_id)
    end

    def user_args_errors(args)
      [].tap do |errors|
        errors << 'No server specified.' if args[:server].nil?
        errors << 'No username specified.' if args[:username].nil?
        errors << 'No password specified.' if args[:password].nil?
      end
    end

    def base_url(proxy, options)
      url = 'http'
      url += 's' if options[:ssl]
      url += "://#{proxy}"
      url += ":#{options[:port]}" if options[:port]
      url
    end
  end
end
