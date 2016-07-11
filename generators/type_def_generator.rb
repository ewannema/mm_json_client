require 'erb'
require 'json'
require 'wasabi'

module MmJsonClient
  module Generators
    # Read in a WSDL and output an API definition file for complex types.
    class TypeDefGenerator
      def generate(in_file, out_file)
        types = {}
        doc = Wasabi.document(File.read(in_file))
        doc.parser.types.each do |type, data|
          types[type] = {}
          if array_type?(type, data)
            ns_type = array_type(data)
            types[type] = [type_from_ns_type(ns_type)]
          else
            type_fields(data).each do |element, definition|
              types[type][element] = type_from_ns_type(definition[:type])
            end
          end
        end

        File.write(out_file, types.to_json)
      end

      private

      def array_type(data)
        type_fields(data).first[1][:type]
      end

      def type_fields(data)
        data.select { |x| x.class == String }
      end

      def type_from_ns_type(ns_type)
        ns_type.split(':').last
      end

      # I would prefer not to do this quite as hackily, but there are
      # other elements in the WSDL that look like have maxOccurs = unbounded,
      # but are not actually array parameters.
      def array_type?(type, _data)
        return true if type =~ /^ArrayOf/
        false
      end
    end
  end
end
