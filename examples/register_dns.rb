#!/usr/bin/env ruby

require 'mm_json_client'

#######################################
# Configuration values from somewhere #
#######################################
server = 'my-ipam.example.com'
username = 'admin'
password = 'password'

ip_address = '10.20.30.2'
dns_zone_name = 'example.com.'
dns_name = 'gemdemo'

#######################################

client = MmJsonClient::Client.new(server: server,
                                  username: username,
                                  password: password)
client.login

#######################
# Get the DNS Zone
#######################
response = client.get_dns_zones(filter: "name:^#{dns_zone_name}$")
raise "DNS Zone #{dns_zone_name} not found" if response.total_results == 0
dns_zone = response.dns_zones.first

dns_record = MmJsonClient::DNSRecord.new(name: dns_name, type: 'A', ttl: nil,
                                         data: ip_address, enabled: true,
                                         dns_zone_ref: dns_zone.ref)

response = client.add_dns_record(dns_record: dns_record)
raise 'Unable to add the DNS record.' unless response.ref

puts "Registered #{dns_name}.#{dns_zone_name} with IP #{ip_address}"
