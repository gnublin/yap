class MainDisplay 

  def initialize
  end

  def ldapQuery(filterKey, filterValue, attrs)
    ldapConnect = Net::LDAP.new :host => Rails.configuration.ldap_host,:port => Rails.configuration.ldap_port
    ldapConnect.auth Rails.configuration.ldap_admin, Rails.configuration.ldap_password
    filter = Net::LDAP::Filter.eq( filterKey, filterValue )
    treebase = Rails.configuration.ldap_treebase
    dataEntries = Hash.new()
    ldapConnect.search( :base => treebase, :filter => filter, :attributes => attrs) do |entry|
       groupDn = entry.dn
       group = groupDn.split(',')[0].split('=')[1].force_encoding('utf-8')
       dataEntries["#{group}"]=Hash.new()
       entry.each do |attribute, values|
            dataEntries["#{group}"]["#{attribute}"] = Hash.new()
            dataEntries["#{group}"]["#{attribute}"]['value'] = Array.new()
            values.each do |value|
                dataEntries["#{group}"]["#{attribute}"]['value'] << value.force_encoding('utf-8')
            end
            dataEntries["#{group}"]["#{attribute}"]['value'] = dataEntries["#{group}"]["#{attribute}"]['value'].sort
        end
    end
    return Hash[dataEntries.sort]
  end

  def people
    return ldapQuery('objectClass', 'inetOrgPerson', ['*', 'memberOf'])
  end

  def group
    return ldapQuery('objectClass', 'groupOfNames', ['*'])
  end

  def userList
    userList = Array.new()
    ldapQuery('objectClass', 'inetOrgPerson', ['dn']).each do |user, value|
        userList << value['dn']['value'][0]
    end
    return userList.sort
  end

  def password
  end

end
