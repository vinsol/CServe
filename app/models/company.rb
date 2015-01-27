class Company < ActiveRecord::Base

  validates :name, :subdomain, presence: true
  validates :subdomain, uniqueness: { case_sensitive: false },
    exclusion: { in: %w(www ssh ftp ), message: "%{value} is reserved." },
    format: { with: REGEX[:subdomain] }, if: -> { subdomain.present? }

  has_many :admins, dependent: :destroy

  accepts_nested_attributes_for :admins

end
