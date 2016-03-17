module Tools

  def md5Pass(password)
    return Net::LDAP::Password.generate(:md5, password)
  end

  def createDn(ou, cn)
    return "cn=#{cn},ou=#{ou}," + Rails.configuration.ldap_treebase
  end

  def uidConstruct(cn)
    nameArray = cn.split(' ')
    if nameArray.length == 1
      uid = "#{nameArray[0].downcase}"
    else
      last = nameArray.pop.downcase
      first = []
      nameArray.each do |constructName|
        first << constructName[0].downcase
      end
      first << last
      uid = first.join
    end
    return uid
  end

  def errCode(code)
    case code
      when 0
        return 'OK : Operation success'
      when 2
        return 'NOK : Entry already exist'
      when 999
        return 'NOK : An error occured'
    end
  end

end
