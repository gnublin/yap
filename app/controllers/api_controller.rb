class ApiController < ApplicationController
  
  def initialize
    @ldapTools = LdapTools.new
  end

  def genPassword
    size = params[:size]
    if ! size
        size = 8
    end
    @apiContent = apiGenPass(size)
    render 'api', content_type: 'application/javascript'
  end

  def ldapManage

    ldapHash = ldapParams
    actionTo = ldapHash[:actionTo]
    cn = ldapHash[:cn].strip
    type = ldapHash[:type]
    uid = ldapHash[:uid]
    passwd = ldapHash[:userpassword]
    @ldapMan = LdapManage.new
    if type 
      ou = @ldapTools.parameters("ldapName")[type]
    end

    case actionTo
      when 'delete'
          dn = LdapGetInfo.new.getDn({:type => 'cn', :value => cn})
          ref = request.referer
          uri = URI(request.referer).path
          uparams = URI::decode_www_form(URI(request.referer).query).to_h
          uparams.delete("msgErr")
           p dn
        if dn
          result = @ldapMan.delete(dn)
          if result == true
            uparams[:msgErr] = 0
          else
            uparams[:msgErr] = 999
          end
        else
          uparams[:msgErr] = 3
        end
          url = "#{uri}?#{uparams.to_query}"
          redirect_to "#{url}"

      when 'edit'
          dn = LdapGetInfo.new.getDn({:type => 'cn', :value => cn})
          ref = request.referer
          uri = URI(request.referer).path
          uparams = URI::decode_www_form(URI(request.referer).query).to_h
          uparams.delete("msgErr")
        if dn
          ldapHash.delete('actionTo')
          ldapHash.delete('cn')
          result = @ldapMan.modify(dn,ldapHash)
          p result
          if result == true
            uparams[:msgErr] = 0
          else
            uparams[:msgErr] = 999
          end
        else
          uparams[:msgErr] = 3
        end
          url = "#{uri}?#{uparams.to_query}"
          redirect_to "#{url}"

      when 'add'
          dn = LdapGetInfo.new.getDn({:type => 'uid', :value => uid})
          p uid
          ref = request.referer
          uri = URI(request.referer).path
          uparams = URI::decode_www_form(URI(request.referer).query).to_h
          uparams.delete("msgErr")
        if !dn
          dn = createDn ou, ldapHash[:cn]
          ldapHash.delete('actionTo')
          result = @ldapMan.add(dn, ldapHash)
          if result == true
            uparams[:msgErr] = 0
          else
            uparams[:msgErr] = 999
          end
        else
          uparams[:msgErr] = 2
        end
          url = "#{uri}?#{uparams.to_query}"
          redirect_to "#{url}"
    end
  end

private 
  def ldapParams
    test = @ldapTools.parameters("ldapForm")[params[:type]]
    params.each_key do |paramsKey|
      if paramsKey == "uid" and params[:"#{paramsKey}"].empty?
        params[:uid] = uidConstruct params[:cn]
      end
      if paramsKey == 'userpassword' and !params[:userpassword].empty? and !params[:userpassword].match('{MD5}')
        params[:userpassword] = md5Pass params[:userpassword]
      end 
      if params[:"#{paramsKey}"].empty?
        params.delete(paramsKey)
      end  
    end 
    params.permit(:sn,:cn,:actionTo,:type,:uid,:mail,:userpassword,:passwd,:member => [])
  end
end
