class SessionsController < ApplicationController

  def initialize 
    @connection = LdapGetInfo.new
  end 

  def new
    if logged_in?
      redirect_to '/yap/dashboard'
    end
  end

  def create
    hash2Dn = Hash.new()
    uid = params[:session][:username]
    @pwd = params[:session][:password]
    hash2Dn[:type] = 'uid'
    hash2Dn[:value] = uid
    @userDn = @connection.getDn(hash2Dn)
    if false === @userDn
      flash.now[:danger] = "d"
      render 'new'
    else
      ldapCheckCredentials = Net::LDAP.new :host => Rails.configuration.ldap_host,:port => Rails.configuration.ldap_port,
      :auth => {
        :username=> @userDn, 
        :password => "#{@pwd}",
        :method => :simple }

      if ldapCheckCredentials.bind
        log_in uid
        redirect_to '/yap/dashboard'
      else
        flash.now[:danger] = 'Invalid email/password combination'
        render 'new'
      end
    end
  end

  def destroy 
    if logged_in?
      log_out
      redirect_to '/'
    end
  end

end
