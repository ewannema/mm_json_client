require 'erb'
require 'json'
require 'wasabi'

module MmJsonClient
  module Generators
    # Read in a WSDL and output an API definition file for methods.
    class MethodDefGenerator
      def generate(in_file, out_file)
        methods = {}
        doc = Wasabi.document(File.read(in_file))
        doc.operations.each do |_method, definition|
          methods[definition[:input]] = definition[:output]
        end

        File.write(out_file, methods.to_json)
      end
    end
  end
end
