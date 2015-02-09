#FIXME_AB: Not all database indexes added to all tables. Why? I did point out this earlier too
class Company < ActiveRecord::Base

  validates :name, :subdomain, presence: true
  #FIXME_AB: Move this list of exclusions in constant or application config
  validates :subdomain, uniqueness: { case_sensitive: false },
    exclusion: { in: %w(www ssh ftp ), message: "%{value} is reserved." },
    format: { with: REGEX[:subdomain] }, if: -> { subdomain.present? }

  #FIXME_AB: Lets use soft-delete. 
  has_many :admins, dependent: :destroy
  has_many :tickets, dependent: :destroy

  accepts_nested_attributes_for :admins

end
