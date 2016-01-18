class LdapGetInfo

  def initialize
    @ldapConnect = Net::LDAP.new :host => Rails.configuration.ldap_host,:port => Rails.configuration.ldap_port
  end

  def getDn(hash2Dn)
    filter = Net::LDAP::Filter.eq( hash2Dn[:type], hash2Dn[:value] )
    treebase = Rails.configuration.ldap_treebase
    dn = @ldapConnect.search( :base => treebase, :filter => filter)
    if dn.empty?
      dn = false
    else
      dn = dn[0][:dn][0]
    end
    return dn
  end

  def memberOf(uid)
    arrayMemberOf = Array.new()
    filter = Net::LDAP::Filter.eq( "uid", uid )
    treebase = Rails.configuration.ldap_treebase
    attr="memberOf"
    @ldapConnect.search( :base => treebase, :filter => filter, :attributes => attr) do |entry|
      entry[:memberOf].each do |memberOfName|
        arrayMemberOf << memberOfName.split(',')[0].split('=')[1]
      end
    end
    return arrayMemberOf
  end

end
