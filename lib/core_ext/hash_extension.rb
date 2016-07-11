require 'core_ext/string_extension.rb'

# Extend hash with helpers specificic to this gem.
class Hash
  # Convert the keys of hashes and arrays of hashes using mm_underscore
  def mm_underscore_keys
    keys_to_mm_underscore(self)
  end

  # Convert the keys of hashes and arrays of hashes using mm_camelize
  def mm_camelize_keys
    keys_to_mm_camel(self)
  end

  def mm_values_to_h
    mm_values_to_hashes(self)
  end

  private

  # Convert the keys of hashes and arrays of hashes to mm_underscore
  def keys_to_mm_underscore(value)
    case value
    when Array
      value.map { |v| keys_to_mm_underscore(v) }
    when Hash
      Hash[value.map { |k, v| [k.mm_underscore, keys_to_mm_underscore(v)] }]
    else
      value
    end
  end

  def keys_to_mm_camel(value)
    case value
    when Array
      value.map { |v| keys_to_mm_camel(v) }
    when Hash
      Hash[value.map { |k, v| [k.mm_camelize, keys_to_mm_camel(v)] }]
    else
      value
    end
  end
end
