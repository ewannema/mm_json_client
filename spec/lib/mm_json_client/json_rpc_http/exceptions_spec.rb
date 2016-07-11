require 'spec_helper'
require 'mm_json_client/generic_type'

describe MmJsonClient::JsonRpcHttp do
  describe 'InvalidResponseFormat' do
    it 'has a default message' do
      e = MmJsonClient::JsonRpcHttp::InvalidResponseFormat.new
      expect(e.message).to eq('Server response format is invalid.')
    end
  end
end
