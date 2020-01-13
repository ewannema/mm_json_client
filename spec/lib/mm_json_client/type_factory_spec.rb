require 'spec_helper'
require 'mm_json_client/type_factory'

describe MmJsonClient::TypeFactory do
  let(:type_factory) { MmJsonClient::TypeFactory }

  # Clean up any defined test constants so we don't get warnings about it.
  after(:each) do
    if MmJsonClient.const_defined?(:TestType)
      MmJsonClient.send(:remove_const, :TestType)
    end

    if MmJsonClient.const_defined?(:Planet)
      MmJsonClient.send(:remove_const, :Planet)
    end

    if MmJsonClient.const_defined?(:ArrayOfPlanet)
      MmJsonClient.send(:remove_const, :ArrayOfPlanet)
    end
  end

  describe '.define' do
    it 'the new class has the appropriate attributes' do
      type_factory.load_types('TestType' => { 'name' => 'string',
                                              'home_planet' => 'string' })
      subject = MmJsonClient::TestType.new
      subject.name = 'The Tick'
      subject.home_planet = 'Earth'

      expect(subject.name).to eq('The Tick')
      expect(subject.home_planet).to eq('Earth')
    end
  end

  describe '.build_from_data' do
    it 'populates the data when all attributes are simple' do
      type_factory.load_types('TestType' => { 'name' => 'string',
                                              'home_planet' => 'string' })

      subject =
        type_factory.build_from_data('TestType', 'name' => 'The Tick',
                                                 'home_planet' => 'Earth')

      expect(subject.name).to eq('The Tick')
      expect(subject.home_planet).to eq('Earth')
    end

    it 'handles types that are aliases for other simple types' do
      type_factory.load_types('TestType' => { 'name' => 'string',
                                              'home_planet' => 'Planet' })

      subject =
        type_factory.build_from_data('TestType', 'name' => 'The Tick',
                                                 'home_planet' => 'earth')

      expect(subject.home_planet).to eq('earth')
    end

    it 'handles nested complex types' do
      type_factory.load_types('TestType' => { 'name' => 'string',
                                              'home_planet' => 'Planet' },
                              'Planet' => { 'name' => 'string' })

      subject =
        type_factory.build_from_data('TestType',
                                     'name' => 'The Tick',
                                     'home_planet' => { 'name' => 'jupiter' })

      expect(subject.home_planet.class).to eq(MmJsonClient::Planet)
      expect(subject.home_planet.name).to eq('jupiter')
    end

    it 'handles arrays of types' do
      type_schema = { 'TestType' => { 'favorite_planets' => 'ArrayOfPlanet' },
                      'ArrayOfPlanet' => ['Planet'],
                      'Planet' => { 'name' => 'string' } }
      type_factory.load_types(type_schema)

      data = { 'favorite_planets' => [{ 'name' => 'earth' },
                                      { 'name' => 'mars' }] }

      subject = type_factory.build_from_data('TestType', data)
      expect(subject.favorite_planets.first.class).to eq(MmJsonClient::Planet)
      planet_names = subject.favorite_planets.map(&:name).sort
      expect(planet_names).to eq(%w(earth mars))
    end

    it 'ignores attributes not in the API spec' do
      type_factory.load_types('TestType' => { 'name' => 'string',
                                              'home_planet' => 'string' })

      subject =
        type_factory.build_from_data('TestType', 'name' => 'The Tick',
                                                 'home_planet' => 'Earth',
                                                 'weakness' => 'shiny objects')

      expect(subject.name).to eq('The Tick')
      expect(subject.home_planet).to eq('Earth')
      expect{subject.weakness}.to raise_error(NoMethodError)
    end
  end
end
