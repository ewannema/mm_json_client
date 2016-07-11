module MmJsonClient
  # The base class for dynamically generated types.
  class GenericType
    def initialize(attributes = {})
      @data = {}
      attributes.each do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
    end

    class << self
      def property(attribute)
        class_eval do
          define_method(attribute) do
            @data[attribute]
          end

          define_method("#{attribute}=") do |value|
            @data[attribute] = value
          end
        end
      end
    end

    def set_properties
      @data.keys.sort.map(&:to_s)
    end

    def to_h
      {}.merge(@data)
    end

    def deep_copy
      Marshal.load(Marshal.dump(self))
    end
  end
end
