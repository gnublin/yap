class LdapManage

  def initialize
    @ldapConnect = Net::LDAP.new :host => Rails.configuration.ldap_host,:port => Rails.configuration.ldap_port
  end

  def add(dn, ldapHash)

    if !ldapHash[:sn] or ldapHash[:sn].empty? and ldapHash[:type] != 'groupOfNames'
      ldapHash[:sn] = ldapHash[:uid] 
    end
    ldapHash[:objectclass] = [ldapHash[:type], 'top']
    ldapHash.delete('type')

    @ldapConnect.auth Rails.configuration.ldap_admin, Rails.configuration.ldap_password
    return @ldapConnect.add :dn => dn, :attributes => ldapHash

  end

  def delete(dn)

    @ldapConnect.auth Rails.configuration.ldap_admin, Rails.configuration.ldap_password
    return @ldapConnect.delete :dn => dn

  end

  def modify(dn, ops)

    modify = Array.new
    ops.delete('type')

    ops.each do |opK, opV|
      modify << [:replace, opK, opV]
    end

    @ldapConnect.auth Rails.configuration.ldap_admin, Rails.configuration.ldap_password
    return @ldapConnect.modify :dn => dn, :operations => modify

  end


end
