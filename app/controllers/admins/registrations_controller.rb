class Admins::RegistrationsController < Devise::RegistrationsController
  helper :subdomain
  before_filter :configure_sign_up_params, only: [:create]

  def new
    @company = Company.new
    super
  end

  def create
    @company = Company.new(company_params)
    @admin = build_resource(sign_up_params)
    if @admin.valid? && @company.valid?
      @company.save
      params[:admin][:company_id] = @company.id
      super
    else
      @company.valid?
      errors = []
      errors = @admin.errors.full_messages if @admin.errors.messages.present?
      @company.errors.full_messages.each do |message|
        errors << 'Company ' + message
      end
      flash[:alert] = errors.to_sentence
      render :new
    end
  end

  protected
  # You can put the params you want to permit in the empty array.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << [:role, :company_id, :name]
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    root_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    root_url
  end

  def company_params
    params[:admin][:company].permit(:name, :subdomain)
  end

end
