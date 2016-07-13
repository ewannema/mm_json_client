require 'spec_helper'
require 'mm_json_client/generic_type'

describe MmJsonClient::GenericType do
  let(:client) do
    MmJsonClient::Client.new(server: 'test-ipam.local',
                             username: 'testuser',
                             password: 'testpass')
  end

  before(:each) do
    klass = Class.new(MmJsonClient::GenericType) do
      property 'name'
      property 'relationships'
    end
    MmJsonClient.const_set 'TestClass', klass
    @subject = klass.new
  end

  after(:each) do
    if MmJsonClient.const_defined?(:TestClass)
      MmJsonClient.instance_eval { remove_const(:TestClass) }
    end
  end

  describe '.client_objects_to_h' do
    it 'converts a simple object to a hash' do
      @subject.name = 'foo'
      expect(client.client_objects_to_h(@subject)).to eq('name' => 'foo')
    end

    it 'converts a child object to a hash' do
      @subject.name = 'foo'
      @subject.relationships = MmJsonClient::TestClass.new(name: 'bar')
      expect(client.client_objects_to_h(@subject)).to eq(
        'name' => 'foo',
        'relationships' => { 'name' => 'bar' }
      )
    end

    it 'correctly processes simple items in an array' do
      @subject.name = 'foo'
      @subject.relationships = [1, 2]
      expect(client.client_objects_to_h(@subject)).to eq(
        'name' => 'foo',
        'relationships' => [1, 2]
      )
    end

    it 'correctly processes client objects in an array' do
      @subject.name = 'foo'
      @subject.relationships =
        [MmJsonClient::TestClass.new(name: 'fizz'),
         MmJsonClient::TestClass.new(name: 'buzz')]
      expect(client.client_objects_to_h(@subject)).to eq(
        'name' => 'foo',
        'relationships' => [{ 'name' => 'fizz' },
                            { 'name' => 'buzz' }]
      )
    end
  end

  describe 'basic server interaction', :vcr do
    it 'allows a user to log in and out' do
      expect(client.login).to eq(true)
      expect(client.logout).to eq(true)
    end

    it 'responds with a server error on bad auth' do
      bad_client = MmJsonClient::Client.new(server: 'test-ipam.local',
                                            username: 'testuser',
                                            password: 'badpadd')
      expected_message = 'code: 16394 ; message: Invalid username or password.'

      expect { bad_client.login }.to raise_error(MmJsonClient::ServerError,
                                                 expected_message)
    end

    it 'gets a list of users' do
      client.login
      users = client.get_users.users

      expect(users.count).to eq(2)
      expect(users.map(&:name).sort).to eq(%w(administrator testuser))
      client.logout
    end

    it 'filters a list of users' do
      client.login
      response = client.get_users(filter: 'name:^testuser$')
      expect(response.total_results).to eq(1)
      expect(response.users.first.name).to eq('testuser')
      client.logout
    end

    it 'gets a user by reference' do
      client.login
      user = client.get_user(user_ref: '{#14-#2}')

      expect(user.user.name).to eq('testuser')

      client.logout
    end
  end

  describe 'ssl options', :vcr do
    # TODO: VCR isn't recording the SSL failure. Need to investigate.
    # it 'rejects an invalid certificate by default' do
    #   ssl_client = MmJsonClient::Client.new(server: 'test-ipam.local',
    #                                        username: 'testuser',
    #                                        password: 'testpass',
    #                                        ssl: true)

    #   expect{ssl_client.login}.to raise_error(OpenSSL::SSL::SSLError,
    #                                         /certificate verify failed/)

    # end

    it 'allows ignoring bad certificates' do
      ssl_client = MmJsonClient::Client.new(server: 'test-ipam.local',
                                            username: 'testuser',
                                            password: 'testpass',
                                            ssl: true,
                                            verify_ssl: false)

      expect(ssl_client.login).to eq(true)
      ssl_client.logout
    end
  end

  describe 'proxy_options', :vcr do
    it 'allows a separate proxy to be defined' do
      client = MmJsonClient::Client.new(proxy: 'test-ipam.local',
                                        server: 'localhost',
                                        username: 'testuser',
                                        password: 'testpass')

      expect(client.login).to eq(true)
    end
  end

  describe 'multiple proxy servers', :vcr do
    it 'connects to another proxy when one is disabled' do
      client = MmJsonClient::Client.new(proxy: ['test-ipam02.local',
                                                'test-ipam01.local'],
                                        server: 'localhost',
                                        username: 'testuser',
                                        password: 'testpass')

      expect(client.login).to eq(true)
    end

    # TODO: VCR isn't recording connection failures. Need to investigate.
    # it 'connects to another proxy when the connection to one times out' do
      # client = MmJsonClient::Client.new(proxy: ['172.16.56.100',
      #                                           'test-ipam01.local'],
      #                                   server: 'localhost',
      #                                   username: 'testuser',
      #                                   password: 'testpass')

      # expect(client.login).to eq(true)
  end
end
