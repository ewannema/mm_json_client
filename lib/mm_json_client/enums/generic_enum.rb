module MmJsonClient
  module Enums
    # The base class for dynamically generated enumerations.
    class GenericEnum
      @values = []

      class << self
        attr_reader :values
      end
    end
  end
end
