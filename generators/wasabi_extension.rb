module Wasabi
  # Extend the parser to find M&M API enumerations.
  class Parser
    attr_accessor :enumerations

    def parse_enumerations
      @enumerations = {}
      schemas.each do |schema|
        schema_namespace = schema['targetNamespace']

        schema.element_children.each do |node|
          namespace = schema_namespace || @namespace

          case node.name
          when 'element'
            simple_type = node.at_xpath('./xs:simpleType', 'xs' => XSD)
            if simple_type && enumeration?(simple_type)
              process_enumeration namespace, complex_type, node['name'].to_s
            end
          when 'simpleType'
            if enumeration?(node)
              process_enumeration namespace, node, node['name'].to_s
            end
          end
        end
      end
    end

    def process_enumeration(namespace, enum, name)
      @enumerations[name] = { namespace: namespace }
      @enumerations[name]['values'] = []
      enum.xpath('./xs:restriction/xs:enumeration', 'xs' => XSD).each do |value|
        @enumerations[name]['values'] << value['value']
      end
    end

    def enumeration?(node)
      if node.at_xpath('./xs:restriction/xs:enumeration', 'xs' => XSD)
        true
      else
        false
      end
    end
  end
end
