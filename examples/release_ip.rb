#!/usr/bin/env ruby

require 'mm_json_client'

#######################################
# Configuration values from somewhere #
#######################################
server = 'my-ipam.example.com'
username = 'admin'
password = 'password'

ip_range = '10.20.30.0/24' # The range the IP is in
ip_address = '10.20.30.2'

#######################################

client = MmJsonClient::Client.new(server: server,
                                  username: username,
                                  password: password)
client.login

#######################
# Get the IP range
#######################
response = client.get_ranges(filter: "name:^#{ip_range}$")
raise "IP Range #{ip_range} not found" if response.total_results == 0
range = response.ranges.first

###############################################
# Get the corresponding IPAM record for the IP
###############################################
response = client.get_ipam_records(range_ref: range.ref,
                                   limit: 1,
                                   filter: "address:^#{ip_address}$")
raise "No IPAM record for #{ip_address}" if response.total_results == 0
ipam_record = response.ipam_records.first

###############################################
# Get a deep copy of the IPAM record to update
# and mark it IPAM record as free
###############################################
updated_ipam_record = ipam_record.deep_copy
updated_ipam_record.state = 'Free'

response = client.set_ipam_record(ipam_record_before: ipam_record,
                                  ipam_record_after: updated_ipam_record)
unless response.errors.empty?
  raise "Unable to release the IPAM record. Errors #{response.errors.inspect}"
end

###################################################
# Verify that the IPAM record is marked as free
###################################################
response = client.get_ipam_record(addr_ref: ipam_record.addr_ref)
if response.ipam_record.state == 'Free'
  puts "#{ip_address} was successfully released."
else
  raise 'Failed to release the IP address.'
end
