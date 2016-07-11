require 'spec_helper'
require 'core_ext/string_extension'

describe String do
  describe '.mm_underscore' do
    it 'does not change existing underscored text' do
      subject = 'i_am_already_good'.mm_underscore
      expect(subject).to eq('i_am_already_good')
    end

    it 'does not remove existing underscores' do
      subject = 'i__am_already_good'.mm_underscore
      expect(subject).to eq('i__am_already_good')
    end

    it 'converts simple camel case' do
      subject = 'iNeedToChange'.mm_underscore
      expect(subject).to eq('i_need_to_change')
    end

    it 'leaves groups of caps together' do
      subject = 'iREALLYNeedToChange'.mm_underscore
      expect(subject).to eq('i_really_need_to_change')
    end

    it 'leaves groups of caps together' do
      subject = 'iREALLYNeedToChange'.mm_underscore
      expect(subject).to eq('i_really_need_to_change')
    end

    it 'correctly handles Pascal case' do
      expect('PascalCase'.mm_underscore).to eq('pascal_case')
    end

    it 'correctly handles multiple caps at start of a Pascal cased word' do
      expect('DBConnector'.mm_underscore).to eq('db_connector')
    end

    it 'correctly handles GetDNSPTRRecords' do
      subject = 'GetDNSPTRRecords'.mm_underscore
      expect(subject).to eq('get_dns_ptr_records')
    end

    it 'correctly handles kskIDs' do
      expect('kskIDs'.mm_underscore).to eq('ksk_ids')
    end

    it 'correctly handles zskIDs' do
      expect('zskIDs'.mm_underscore).to eq('zsk_ids')
    end

    it 'correctly handles interfaceID' do
      expect('interfaceID'.mm_underscore).to eq('interface_id')
    end

    it 'correctly handles VLANID' do
      expect('VLANID'.mm_underscore).to eq('vlan_id')
    end

    it 'correctly handles VRFName' do
      expect('VRFName'.mm_underscore).to eq('vrf_name')
    end
  end

  describe '.mm_camelize' do
    it 'converts simple snake case' do
      expect('snake_case'.mm_camelize).to eq('snakeCase')
    end

    it 'converts AD acronyms at the beginning correctly' do
      expect('ad_site'.mm_camelize).to eq('adSite')
    end

    it 'converts DHCP acronyms at the beginning correctly' do
      expect('dhcp_lease'.mm_camelize).to eq('dhcpLease')
    end

    it 'converts DNS acronyms at the beginning correctly' do
      expect('dns_record'.mm_camelize).to eq('dnsRecord')
    end

    it 'converts IP acronyms at the beginning correctly' do
      expect('ip_address'.mm_camelize).to eq('ipAddress')
    end

    it 'converts IPAM acronyms at the beginning correctly' do
      expect('ipam_record'.mm_camelize).to eq('ipamRecord')
    end

    it 'converts PTR acronyms at the beginning correctly' do
      expect('ptr_status'.mm_camelize).to eq('ptrStatus')
    end

    it 'converts PTR acronyms at the end correctly' do
      expect('extraneous_ptr'.mm_camelize).to eq('extraneousPTR')
    end

    it 'correctly handles ksk_ids' do
      expect('ksk_ids'.mm_camelize).to eq('kskIDs')
    end

    it 'correctly handles zskIDs' do
      expect('zsk_ids'.mm_camelize).to eq('zskIDs')
    end

    it 'correctly handles interfaceID' do
      expect('interface_id'.mm_camelize).to eq('interfaceID')
    end

    it 'correctly handles VLANID' do
      expect('vlan_id'.mm_camelize).to eq('VLANID')
    end

    it 'correctly handles VRFName' do
      expect('vrf_name'.mm_camelize).to eq('VRFName')
    end
  end

  describe '.mm_pascalize' do
    it 'converts simple snake case' do
      expect('snake_case'.mm_pascalize).to eq('SnakeCase')
    end

    it 'converts AD acronyms at the beginning correctly' do
      expect('ad_forest'.mm_pascalize).to eq('ADForest')
    end

    it 'converts AD acronyms in the middle correctly' do
      expect('get_ad_site'.mm_pascalize).to eq('GetADSite')
    end

    it 'converts DCHP acronyms at the beginning correctly' do
      subject = 'dchp_scope_options_report_entry'.mm_pascalize
      expect(subject).to eq('DCHPScopeOptionsReportEntry')
    end

    it 'converts DHCP acronyms at the beginning correctly' do
      subject = 'dhcp_address_pool'.mm_pascalize
      expect(subject).to eq('DHCPAddressPool')
    end

    it 'converts DHCP acronyms in the middle correctly' do
      subject = 'get_dhcp_address_pool'.mm_pascalize
      expect(subject).to eq('GetDHCPAddressPool')
    end

    it 'converts DNS acronyms at the beginning correctly' do
      subject = 'dns_zone'.mm_pascalize
      expect(subject).to eq('DNSZone')
    end

    it 'converts DNS acronyms in the middle correctly' do
      subject = 'get_dns_zone'.mm_pascalize
      expect(subject).to eq('GetDNSZone')
    end

    it 'converts IP acronyms at the beginning correctly' do
      subject = 'ip_address'.mm_pascalize
      expect(subject).to eq('IPAddress')
    end

    it 'converts IP acronyms in the middle correctly' do
      subject = 'get_range_by_ip_address'.mm_pascalize
      expect(subject).to eq('GetRangeByIPAddress')
    end

    it 'converts IPAM acronyms at the beginning correctly' do
      subject = 'ipam_record'.mm_pascalize
      expect(subject).to eq('IPAMRecord')
    end

    it 'converts IPAM acronyms in the middle correctly' do
      subject = 'get_ipam_record'.mm_pascalize
      expect(subject).to eq('GetIPAMRecord')
    end

    it 'converts PTR acronyms at the beginning correctly' do
      subject = 'ptr_status'.mm_pascalize
      expect(subject).to eq('PTRStatus')
    end

    it 'converts PTR acronyms in the middle correctly' do
      subject = 'get_dns_ptr_records'.mm_pascalize
      expect(subject).to eq('GetDNSPTRRecords')
    end
  end

  describe '.mm_pluralize' do
    it 'handles simple nouns' do
      expect('GetRange'.mm_pluralize).to eq('GetRanges')
    end

    it 'handles nouns ending in y' do
      expect('Property'.mm_pluralize).to eq('Properties')
    end
  end
end
