class LdapTools

  def initialize
    @permsYaml = YAML::load_file("#{Rails.root}/config/permission_#{Rails.env}.yaml")
    @parametersYaml = YAML::load_file("#{Rails.root}/config/yap_parameters.yaml")
  end

  def perms(memberOf,menuName)
    @perms = false
    memberOf.each do |perms|
      if !@permsYaml[perms]
        perms = 'default'
      end
      if !@permsYaml[perms]['read']
        arrayRead = []
      else
        arrayRead = @permsYaml[perms]['read']
      end
      if !@permsYaml[perms]['write']
        arrayWrite = []
      else
        arrayWrite = @permsYaml[perms]['write']
      end

      if arrayRead.include? menuName and @perms === false
        @perms = 'read'
      end
      if arrayWrite.include? menuName and @perms != 'write'
        @perms = 'write'
      end
    end

    return @perms
  end

  def menu(memberOf)
    menuTab = Array.new
    if !memberOf.kind_of?(Array)
      memberOf.split(' ')
    end
    memberOf.each do |perms|
      if !@permsYaml[perms]
        perms = 'default'
      end
      if !@permsYaml[perms]['read']
        arrayRead = []
      else
        arrayRead = @permsYaml[perms]['read']
      end
      if !@permsYaml[perms]['write']
        arrayWrite = []
      else
        arrayWrite = @permsYaml[perms]['write']
      end

      menuArray = arrayRead + arrayWrite
      menuArray.each do |name|
        menuTab << name
      end
      
    end
    menuTab = menuTab.uniq.sort

    return menuTab
  end

  def menuLeft(menuName)
    if @parametersYaml["#{menuName}"]
      return @parametersYaml["#{menuName}"]
    else
      return false
    end
  end

  def parameters(key)
    return @parametersYaml[key]
  end

end
