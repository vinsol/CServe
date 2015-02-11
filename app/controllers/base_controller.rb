class BaseController < ApplicationController

  layout 'admins'

  before_action :current_company
  before_action :authenticate_admin!

end
