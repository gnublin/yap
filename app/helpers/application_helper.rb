module ApplicationHelper
  def apiGenPass(size)
    password = SecureRandom.urlsafe_base64(size-2)
    password = password.gsub(/-/,'0').gsub(/_/,'4')

    passwordMD5 =  Net::LDAP::Password.generate(:md5, password)
    return "var password = '"+ password + "';\nvar passwordMD5 = '"+ passwordMD5 +"';"
  end
end
