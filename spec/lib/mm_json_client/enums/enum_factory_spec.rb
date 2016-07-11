require 'spec_helper'
require 'mm_json_client/enums/enum_factory'

describe MmJsonClient::Enums::EnumFactory do
  let(:enum_factory_class) { MmJsonClient::Enums::EnumFactory }

  after(:each) do
    if MmJsonClient.const_defined?(:TestEnum)
      MmJsonClient.send(:remove_const, :TestEnum)
    end
  end

  describe '.define' do
    it 'creates a new enum constant' do
      enum_factory_class.load_enums('TestEnum' => %w(Bar Foo))
      expect(MmJsonClient::Enums::TestEnum.values).to eq(%w(Bar Foo))
    end
  end
end
