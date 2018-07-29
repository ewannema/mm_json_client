[![Build Status](https://travis-ci.org/ewannema/mm_json_client.svg?branch=master)](https://travis-ci.org/ewannema/mm_json_client)

# MmJsonClient

The MmJsonClient gem is used to access the Men and Mice IPAM API using the
JSON-RPC format that was first made available in version 6.6.

## API Versions ##
In order to minimize run time dependencies this gem includes API definition
files that define the enumerations, methods and types available when using the
gem.

Different versions of this gem support different versions of the API by default.
See [API Definitions](api_definitions.md) for more information.

| Gem Version | Default API Version |
| ----------- | ------------------- |
| 0.x         | 7.x                 |
| 2.x         | 9.x                 |

## Usage

### Basic Connection Setup

```ruby
require 'mm_json_client'
client = MmJsonClient::Client.new(server: 'my-ipam.example.com',
                                  username: 'demo',
                                  password: 'demo')
client.login
```

Optional parameters to ```Client.new``` are:

| Parameter    | Values     | Purpose |
| -----------  | ---------- | ------- |
|endpoint:     | string     | The URI for the web service. Defaults to /_mmwebext/mmwebext.dll?Soap. |
|open\_timeout:| integer    | Seconds to wait for the initial connection to time out. Defaults to 10.|
|port:         | integer    | The TCP port for the connection. Defaults to 80 or 443 if SSL is enabled. |
|proxy:        | string     | The M&M API server. Defaults to the same as the server: parameter. |
|ssl:          | true/false | Use SSL for the connection. Defaults to false.|
|verify\_ssl:  | true/false | Whether to validate SSL certificates. Defaults to true.|

### Advanced Connection Setup

The client can optionally take an array of servers for the ```proxy:```
parameter. This allows you to have redundant API servers without a load
balancer.

This also allows you to handle the case where the web server is running
on the same servers as the Central service in a cluster configuration.
This is important, because in this architecture the web component
connects to the local server instead of using the DNS round robin entry
and if you pick the inactive server then you will receive an error about
operations being disabled.

```ruby
# When you have multiple web servers that are not behind a load balancer.
client = MmJsonClient::Client.new(proxy: ['my-ipam01.example.com',
                                          'my-ipam02.example.com'],
                                  server: 'ipam-cluster-name.example.com',
                                  username: 'demo',
                                  password: 'demo')

# When you have the web role on the M&M central servers in a cluster and need
# to make sure you can connect to a functioning one.
client = MmJsonClient::Client.new(proxy: ['my-ipam01.example.com',
                                          'my-ipam02.example.com'],
                                  server: 'localhost',
                                  username: 'demo',
                                  password: 'demo')
```

### Case Conversion

Methods, parameters, and values returned from the API use snake case instead of
camel case as listed in the M&M API docs. Class and enumeration names still use
Pascal case.

### Making Requests

The methods in the M&M API will be available directly on the client. Any
required or optional parameters can be included as a hash. The client will
return a response object that matches what is in the API docs.

### Retrieving Data

```ruby
# Get all of the DNS zones
response = client.get_dns_zones
puts "Found #{response.total_results} zones on the server."
puts "The first one is #{response.dns_zones.first.name}."

# Search for a particular zone
response = client.get_dns_zones(filter: 'name:^demo.example.com.$')
puts "Found #{response.total_results} zones on the server."
puts "The first one is #{response.dns_zones.first.name}."

# Get all sub-zones from a particular zone.
response = client.get_dns_zones(filter: 'name:example.com.$')
puts "Found #{response.total_results} zones on the server."
puts "The first one is #{response.dns_zones.first.name}."

# Get a single dns zone by reference.
response = client.get_dns_zone(dns_zone_ref: '{#4-#1000}')
zone = response.dns_zone
puts "The zone name is #{zone.name}."
```

### Making Changes

When you need to create a type to use as a parameter to a method you will
instantiate it, modify it as necessary and then pass it in.

```ruby
new_user = MmJsonClient::User.new
new_user.name = 'demouser'
new_user.password = 'password'
new_user.authentication_type = 'Internal'

# or

new_user = MmJsonClient::User.new(name: 'demouser',
                                  password: 'password',
                                  authentication_type: 'Internal')

# and then
client.add_user(user: new_user)
```

### Enumerated Values

Some fields in the API such as AuthenticationType are enumerated values. To
see valid values for the enumation use the ```.values``` method.

```ruby
MmJsonClient::Enums::AuthenticationType.values
=> ["Internal", "AD", "ADGroup", "RADIUS"]
```

### Learning and Exploration

There are some [examples](examples/) in this repository.

Check out the SOAP API docs on your server. Although this gem is using the
JSON-RPC API, the methods, types, enumerations and responses are the same.

If you have completion enabled in your IRB session you will be able to complete
on method, type, and enumeration names.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ewannema/mm_json_client.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

