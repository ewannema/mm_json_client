require 'json'
require 'spec_helper'
require 'tempfile'
require_relative '../../generators/type_def_generator'

describe MmJsonClient::Generators::TypeDefGenerator do
  before(:all) do
    spec_wsdl = File.join(File.dirname(File.expand_path(__FILE__)), 'spec.wsdl')
    generator = MmJsonClient::Generators::TypeDefGenerator.new
    @subject_file = Tempfile.new('type_def_test_json')
    generator.generate(spec_wsdl, @subject_file)
    @subject = JSON.parse(File.read(@subject_file))
  end

  after(:all) do
    @subject_file.close
    @subject_file.unlink
  end

  describe '.generate' do
    it 'generates a file with the right number of types' do
      expect(@subject.keys.count).to eq(630)
    end
  end
end
