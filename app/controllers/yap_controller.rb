class YapController < ApplicationController

  def initialize
    @ldapTools = LdapTools.new
  end

  def dashboard
    if testLoggedIn
      @userDn = session[:user_id]
      current_user
      getMemberOf = LdapGetInfo.new 
      @memberOf = getMemberOf.memberOf(session[:user_id])
      @current_menu = @ldapTools.menu(@memberOf)
      render layout: "yap"
    else
      redirect_to '/'
    end
  end

  def index
  end

  def show
    @msgErr = params[:msgErr]
    @id = params[:id]
    @subId = params[:sub]
    if @msgErr
      @msgErr = errCode(@msgErr)
    end
    if !testLoggedIn
      redirect_to '/'
    end
    current_user
    getMemberOf = LdapGetInfo.new 
    @memberOf = getMemberOf.memberOf(session[:user_id])
    @current_menu = @ldapTools.menu(@memberOf)
    @permission = @ldapTools.perms(@memberOf,@id)
    @menuLeft = @ldapTools.menuLeft(@id)
    if !@permission 
    #  redirect_to '/yap/dashboard'
      p "dd"
    else
      if @subId
        if MainDisplay.new.respond_to?(@subId)
          @ldapMainInfo = MainDisplay.new
          @displayMainFrame = @ldapMainInfo.send(@subId)
          @form = @ldapTools.parameters("#{@id}Form")
          @mapName = @ldapTools.parameters("#{@id}Name")
          @templateMain = "#{@id}_#{@subId}"
          @subName = @menuLeft[@subId]
          @userList = @ldapMainInfo.userList
        end
      end
      render layout: "yap"
    end
  end

  def logout
    log_out
  end

  def not_found
    redirect_to "/yap/dashboard"
  end

end

