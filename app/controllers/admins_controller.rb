class AdminsController < ApplicationController

  before_filter :authenticate_admin!, only: [:index]

  def index
    @admin = current_admin
  end

end
