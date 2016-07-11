require 'mm_json_client/enums/generic_enum'
require 'mm_json_client/generic_type'

module MmJsonClient
  module Enums
    # Create enumeration classes for the api definition.
    class EnumFactory
      class << self
        def load_enums(enums = {})
          enums.each { |name, values| define(name, values) }
        end

        private

        def define(enum_name, enum_values)
          klass = Class.new(MmJsonClient::Enums::GenericEnum) do
            @values = enum_values
          end
          MmJsonClient::Enums.const_set enum_name, klass
        end
      end
    end
  end
end
