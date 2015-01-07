class Company < ActiveRecord::Base
  validates :name, :subdomain, presence: true
  validates :subdomain, uniqueness: true, format: { with: /\A[a-z\d]+([-_][a-z\d]+)*\Z/i }
  validates :subdomain, uniqueness: true
  has_many :admins, dependent: :destroy
end
