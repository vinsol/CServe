class Company < ActiveRecord::Base
  validates :name, :subdomain, presence: true
  validates :subdomain, uniqueness: true
  has_many :admins, dependent: :destroy
end
