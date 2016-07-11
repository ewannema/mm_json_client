require 'core_ext/hash_extension.rb'
require 'core_ext/string_extension.rb'
require 'core_ext/symbol_extension.rb'
require 'mm_json_client/client'
require 'mm_json_client/enums/enum_factory'
require 'mm_json_client/type_factory'
require 'mm_json_client/version'

# Configure the environment so the gem works.
module MmJsonClient
  # Dynamically load the enums, methods and types from the default api
  # definitions or those put in the directory provided in the environment
  # variable API_DEF_DIR.
  def self.initialize_environment
    load_type_data
    load_enum_data
    define_api_methods
  end

  class << self
    def this_dir
      File.dirname(File.expand_path(__FILE__))
    end

    def api_def_dir
      return ENV['API_DEF_DIR'] if ENV['API_DEF_DIR']
      default_api_def_dir
    end

    def default_api_def_dir
      File.join(this_dir, 'mm_json_client', 'api_definitions')
    end

    def load_type_data
      type_file = File.join(api_def_dir, 'types.json')
      types = JSON.parse(File.read(type_file))
      MmJsonClient::TypeFactory.load_types(types)
    end

    def load_enum_data
      enum_file = File.join(api_def_dir, 'enums.json')
      enums = JSON.parse(File.read(enum_file))
      MmJsonClient::Enums::EnumFactory.load_enums(enums)
    end

    def static_methods
      %w(Login Logout)
    end

    def dynamic_methods(methods)
      methods.reject { |k, _v| static_methods.include?(k) }
    end

    def define_api_methods
      method_file = File.join(api_def_dir, 'methods.json')
      all_methods = JSON.parse(File.read(method_file))
      dynamic_methods(all_methods).each do |method, return_type|
        MmJsonClient::Client.define_api_method(method, return_type)
      end
    end
  end
end

MmJsonClient.initialize_environment
