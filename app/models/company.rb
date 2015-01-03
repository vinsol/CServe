class Company < ActiveRecord::Base
  validates :name, :subdomain, presence: true
  validates :subdomain, uniqueness: true
end
