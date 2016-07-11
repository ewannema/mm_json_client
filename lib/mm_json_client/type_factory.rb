require 'mm_json_client/generic_type'

module MmJsonClient
  # Dynamically create types and simplify their instantiation.
  class TypeFactory
    @types = {}

    # Create type classes for the api definition.
    def self.load_types(types = {})
      types.each { |type, definition| define(type, definition) }
    end

    def self.build_from_data(type_name, data = {})
      return build_array_type(type_name, data) if data.class == Array
      return build_simple_type(type_name, data) if simple_type?(type_name)
      build_complex_type(type_name, data)
    end

    class << self
      attr_reader :types

      private

      def define(type_name, definition)
        if definition.class == Array
          add_type_definition(type_name, definition)
        else
          snaked_definition = definition.mm_underscore_keys
          add_type_definition(type_name, snaked_definition)

          klass = Class.new(MmJsonClient::GenericType) do
            snaked_definition.each { |attribute, _type| property attribute }
          end

          MmJsonClient.const_set type_class_name(type_name), klass
        end
      end

      def build_array_type(type_name, data)
        array_type = type_definition(type_name).first
        data.map { |d| build_from_data(array_type, d) }
      end

      def build_simple_type(_type_name, data)
        data
      end

      def build_complex_type(type_name, data)
        MmJsonClient.const_get(type_class_name(type_name)).new.tap do |obj|
          type_def = type_definition(type_name)
          data.each do |attr_name, value|
            subtype = type_def[attr_name]
            obj.send("#{attr_name}=", build_from_data(subtype, value))
          end
        end
      end

      # TODO: Find a way to consistently deal with weirdly cased items like
      # this. Since we won't be sending the type name into the API this
      # conversion is currently ok.
      def type_class_name(type_name)
        return type_name if type_name[0].upcase == type_name[0]
        "#{type_name[0].upcase}#{type_name[1..-1]}"
      end

      def type_defined?(type_name)
        types.include?(type_name)
      end

      def add_type_definition(type_name, definition)
        @types[type_name] = definition
      end

      def type_definition(type_name)
        types[type_name]
      end

      def simple_type?(type_name)
        !type_defined?(type_name)
      end
    end
  end
end
