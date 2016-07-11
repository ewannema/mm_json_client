require 'spec_helper'
require 'mm_json_client/enums/generic_enum'

describe MmJsonClient::Enums::GenericEnum do
  before(:each) do
    klass = Class.new(MmJsonClient::Enums::GenericEnum) do
      @values = %w(Fizz Buzz)
    end

    MmJsonClient::Enums.const_set 'TestEnum', klass
  end

  after(:each) do
    if MmJsonClient.const_defined?(:TestEnum)
      MmJsonClient.instance_eval { remove_const(:TestEnum) }
    end
  end

  describe '.values' do
    it 'contains the appropriate values' do
      expect(MmJsonClient::Enums::TestEnum.values.sort).to eq(%w(Buzz Fizz))
    end
  end
end
