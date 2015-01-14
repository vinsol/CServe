class AdminsController < ApplicationController

  before_filter :authenticate_admin!, only: [:index]

  def index
    #FIXME_AB: no need to define an instance method @admin you can directly use current_admin
    @admin = current_admin
  end

end
