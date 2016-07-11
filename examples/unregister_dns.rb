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

#######################
# Get the DNS Record
#######################
# must match name, ip, and record type
record_filter = "name:^#{dns_name}$ data:^#{ip_address}$ type:A"
response = client.get_dns_records(filter: record_filter,
                                  dns_zone_ref: dns_zone.ref)
if response.total_results == 0
  raise "DNS record #{dns_name}.#{dns_zone_name} not found"
end
dns_record = response.dns_records.first

client.remove_object(ref: dns_record.ref, obj_type: 'DNSRecord')

puts "DNS record #{dns_name}.#{dns_zone_name} removed"
