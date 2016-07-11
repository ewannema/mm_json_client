require 'json'
require 'spec_helper'
require 'tempfile'
require_relative '../../generators/method_def_generator'

describe MmJsonClient::Generators::MethodDefGenerator do
  before(:all) do
    spec_wsdl = File.join(File.dirname(File.expand_path(__FILE__)), 'spec.wsdl')
    generator = MmJsonClient::Generators::MethodDefGenerator.new
    @subject_file = Tempfile.new('method_def_test_json')
    generator.generate(spec_wsdl, @subject_file)
    @subject = JSON.parse(File.read(@subject_file))
  end

  after(:all) do
    @subject_file.close
    @subject_file.unlink
  end

  describe '.generate' do
    it 'generates a file with the right number of methods' do
      expect(@subject.keys.count).to eq(196)
    end
  end
end
