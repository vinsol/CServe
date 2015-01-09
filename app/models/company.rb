class Company < ActiveRecord::Base

  validates :name, :subdomain, presence: true
  validates :subdomain, uniqueness: true, format: { with: /\A[a-z\d]+([-_][a-z\d]+)*\Z/i }, if: "subdomain.present?"
  has_many :admins, dependent: :destroy

end
