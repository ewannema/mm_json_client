require 'core_ext/string_extension'

# Extend symbol with helpers specificic to this gem.
class Symbol
  # Underscore functionality to match conversion from M&M values.
  def mm_underscore
    to_s.mm_underscore.to_sym
  end

  # Convert snake case to camel case while honoring acronyms.
  def mm_camelize
    to_s.mm_camelize.to_sym
  end

  # Convert snake case to Pascal case while honoring acronyms.
  def mm_pascalize
    to_s.mm_pascalize.to_sym
  end

  # Simplistic pluralization for M&M types
  def mm_pluralize
    to_s.mm_pluralize.to_sym
  end
end
