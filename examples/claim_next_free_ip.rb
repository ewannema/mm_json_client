#!/usr/bin/env ruby

require 'mm_json_client'

#######################################
# Configuration values from somewhere #
#######################################
server = 'my-ipam.example.com'
username = 'admin'
password = 'password'

# Options for finding the IP.
ping_verify = false # try to ping the IP address
claim_time = 30     # seconds to temporarily claim the record to avoid
                    #   race conditions
exclude_dhcp = true # exclude DHCP ranges from available IPs

ip_range = '10.20.30.0/24' # The range to pull the IP from

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
# Get the first available address in the range
###############################################
response = client.get_next_free_address(range_ref: range.ref,
                                        ping: ping_verify,
                                        exclude_dhcp: exclude_dhcp,
                                        temporary_claim_time: claim_time)
ip_address = response.address

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
# and mark it IPAM record as claimed.
###############################################
updated_ipam_record = ipam_record.deep_copy
updated_ipam_record.state = 'Claimed'

response = client.set_ipam_record(ipam_record_before: ipam_record,
                                  ipam_record_after: updated_ipam_record)
unless response.errors.empty?
  raise "Unable to claim the IPAM record. Errors #{response.errors.inspect}"
end

###################################################
# Verify that the IPAM record is marked as claimed
###################################################
response = client.get_ipam_record(addr_ref: ipam_record.addr_ref)
if response.ipam_record.state == 'Claimed'
  puts "#{ip_address} was successfully claimed."
else
  raise 'Failed to claim an IP address.'
end
