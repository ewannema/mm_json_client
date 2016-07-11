# Extend string with helpers specificic to this gem.
class String
  MM_Acronyms = %w(AD DCHP DHCP DNS ID IP IPAM PTR VLAN VRF).freeze
  MM_Upper_In_Camel = %w(VLAN VRF).freeze

  # Underscore functionality to match conversion from M&M values.
  def mm_underscore
    return self if self =~ /^[a-z_]+$/

    # handle fields that are IDs
    underscored = gsub(/IDs/, '_ids')

    # break on lower to upper transition
    underscored.gsub!(/([a-z])([A-Z]+)/) do
      "#{Regexp.last_match(1)}_#{Regexp.last_match(2)}"
    end

    # break on acronym to caps word transition
    underscored.gsub!(/([A-Z])([A-Z][a-z]+)/) do
      "#{Regexp.last_match(1)}_#{Regexp.last_match(2)}"
    end

    # special case separation
    underscored.gsub!(/DNSPTR/i, 'dns_ptr')
    underscored.gsub!(/VLANID/i, 'vlan_id')

    underscored.downcase
  end

  # Convert snake case to camel case while honoring acronyms.
  def mm_camelize
    first = split('_')[0]
    first = first.upcase if MM_Upper_In_Camel.include?(first.upcase)
    remaining = split('_').drop(1)
    camelized = remaining.map { |p| mm_capitalize_with_acronyms(p) }
    camelized.insert(0, first)
    camelized.join
  end

  # Convert snake case to Pascal case while honoring acronyms.
  def mm_pascalize
    split('_').map { |p| mm_capitalize_with_acronyms(p) }.join
  end

  # Simplistic pluralization for M&M types
  def mm_pluralize
    if self =~ /y$/
      "#{chomp('y')}ies"
    else
      "#{self}s"
    end
  end

  private

  def mm_capitalize_with_acronyms(word)
    return 'IDs' if word == 'ids'
    MM_Acronyms.include?(word.upcase) ? word.upcase : word.capitalize
  end
end
