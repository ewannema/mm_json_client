require 'spec_helper'
require 'mm_json_client/generic_type'

describe MmJsonClient::GenericType do
  before(:each) do
    klass = Class.new(MmJsonClient::GenericType) do
      property 'name'
      property 'relationships'
    end
    MmJsonClient.const_set 'TestType', klass
    @subject = klass.new
  end

  after(:each) do
    if MmJsonClient.const_defined?(:TestType)
      MmJsonClient.send(:remove_const, :TestType)
    end
  end

  describe '.to_h' do
    it 'converts a simple object to a hash' do
      @subject.name = 'foo'
      expect(@subject.to_h).to eq('name' => 'foo')
    end
  end
end
