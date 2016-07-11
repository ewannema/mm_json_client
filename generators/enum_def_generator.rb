require 'erb'
require 'json'
require 'wasabi'
require_relative 'wasabi_extension'

module MmJsonClient
  module Generators
    # Read in a WSDL and output an API definition file for enumerations.
    class EnumDefGenerator
      def generate(in_file, out_file)
        enumerations = {}
        doc = Wasabi.document(File.read(in_file))
        doc.parser.parse_enumerations
        doc.parser.enumerations.each do |enumeration, data|
          enumerations[enumeration] = data['values']
        end

        File.write(out_file, enumerations.to_json)
      end
    end
  end
end
