class Admin < ActiveRecord::Base
  validates :name, presence: true
  validates :password_confirmation, presence: true, if: :password
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company
  paginates_per 20
  delegate :subdomain, to: :company
  delegate :name, to: :company, prefix: true

  def save_without_confirmation
    self.password = DEFAULT_ADMIN_PASSWORD
    self.password_confirmation = DEFAULT_ADMIN_PASSWORD
    skip_confirmation!
    saved = save
    if saved
      token = set_reset_password_token
      AdminMailer.set_password_instructions(self, token).deliver
    end
    saved
  end

  def update_with_password(params, *options)
    current_password = params.delete(:current_password)
    result = if valid_password?(current_password)
      update_attributes(params, *options)
    else
      self.assign_attributes(params, *options)
      self.valid?
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end

    clean_up_passwords
    result
  end

end
