class Company < ActiveRecord::Base
  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true, format: { with: /\A[a-z\d]+([-_][a-z\d]+)*\Z/i }
end
