class Admin < ActiveRecord::Base
  validates :name, presence: true
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company

  def subdomain
    company.subdomain
  end

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

end
