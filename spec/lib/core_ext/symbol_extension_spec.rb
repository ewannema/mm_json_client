require 'spec_helper'
require 'core_ext/symbol_extension'

# This test suite is not fully fleshed out as it relies upon the tests for the
# string extension.
describe Symbol do
  describe '.mm_underscore' do
    it 'returns the expected symbol' do
      subject = :iNeedToChange.mm_underscore
      expect(subject).to eq(:i_need_to_change)
    end
  end

  describe '.mm_camelize' do
    it 'returns the expected symbol' do
      expect(:snake_case.mm_camelize).to eq(:snakeCase)
    end
  end

  describe '.mm_pascalize' do
    it 'returns the expected symbol' do
      expect(:snake_case.mm_pascalize).to eq(:SnakeCase)
    end
  end

  describe '.mm_pluralize' do
    it 'returns the expected symbol' do
      expect(:GetRange.mm_pluralize).to eq(:GetRanges)
    end
  end
end
