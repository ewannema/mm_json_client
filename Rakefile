require 'bundler/gem_tasks'
require_relative 'generators/enum_def_generator'
require_relative 'generators/method_def_generator'
require_relative 'generators/type_def_generator'
require 'rspec/core/rake_task'
require 'wasabi'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

namespace :generate do
  desc 'Generate a type definition file from a WSDL.'
  task :type_def do
    ARGV.each { |a| task a.to_sym {} }
    generator = MmJsonClient::Generators::TypeDefGenerator.new
    generator.generate(ARGV[1], ARGV[2])
  end

  desc 'Generate an enum definition file from a WSDL.'
  task :enum_def do
    ARGV.each { |a| task a.to_sym {} }
    generator = MmJsonClient::Generators::EnumDefGenerator.new
    generator.generate(ARGV[1], ARGV[2])
  end

  desc 'Generate an method definition file from a WSDL.'
  task :method_def do
    ARGV.each { |a| task a.to_sym {} }
    generator = MmJsonClient::Generators::MethodDefGenerator.new
    generator.generate(ARGV[1], ARGV[2])
  end
end
