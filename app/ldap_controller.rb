class LdapController < ApplicationController

  def index
    @test = 'value1'
  end

  def show
    redirect_to '/'
  end

end
