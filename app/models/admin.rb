#FIXME_AB: required indexes are missing
class Admin < ActiveRecord::Base
  #FIXME_AB: Few other required validations are missing
  validates :name, presence: true
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :company

  #FIXME_AB: use delegate for the following. 
  def subdomain
    company.subdomain
  end
end
