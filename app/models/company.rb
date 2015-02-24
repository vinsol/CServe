class Company < ActiveRecord::Base

  require 'securerandom'

  validates :name, :subdomain, :support_email, presence: true
  validates :subdomain, uniqueness: { case_sensitive: false },
    exclusion: { in: RESERVED_SUBDOMAINS, message: "%{value} is reserved." },
    format: { with: REGEX[:subdomain] }, if: -> { subdomain.present? }
  validates :support_email, uniqueness: true, allow_blank: true

  has_many :admins, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :categories, dependent: :destroy

  accepts_nested_attributes_for :admins

  after_create :set_confirmation_token, :send_support_email_confirmation_mail

  private

    def set_confirmation_token
      self.update(confirmation_token: SecureRandom.hex)
    end

    def send_support_email_confirmation_mail
      CompanyMailer.confirmations_instructions(self, self.confirmation_token).deliver
    end

end
