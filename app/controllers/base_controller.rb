class BaseController < ApplicationController

  layout 'admins'

  before_action :authenticate_company!
  before_action :authenticate_admin!

end
