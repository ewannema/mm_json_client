require 'json'
require 'spec_helper'
require 'tempfile'
require_relative '../../generators/enum_def_generator'

describe MmJsonClient::Generators::EnumDefGenerator do
  before(:all) do
    spec_wsdl = File.join(File.dirname(File.expand_path(__FILE__)), 'spec.wsdl')
    generator = MmJsonClient::Generators::EnumDefGenerator.new
    @subject_file = Tempfile.new('enum_def_test_json')
    generator.generate(spec_wsdl, @subject_file)
    @subject = JSON.parse(File.read(@subject_file))
  end

  after(:all) do
    @subject_file.close
    @subject_file.unlink
  end

  describe '.generate' do
    it 'generates a file with the right number of enums' do
      expect(@subject.keys.count).to eq(58)
    end

    it 'has the correct Status enum' do
      expected_statuses = %w(Green Orange Red Unchecked)
      expect(@subject['Status'].sort).to eq(expected_statuses)
    end
  end
end
