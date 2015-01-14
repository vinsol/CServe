#FIXME_AB: Database index are missing. whenever you create table or column, always cross check for required indexes on table.
class Company < ActiveRecord::Base

  validates :name, :subdomain, presence: true
  #FIXME_AB: This regexp can be reused, so as a good practice extract it as a constant hash.
  validates :subdomain, uniqueness: { case_sensitive: false }, format: { with: /\A[a-z\d]+([-_][a-z\d]+)*\Z/i }, if: "subdomain.present?"
  #FIXME_AB: We should have one validation for subdomain exclusion. like a list subdomains can not be picked. like www, ftp etc.
  #FIXME_AB: Lets not to dependent destroy. Please consult with Atul how to handle cases when we destroy a record. We should be very cautious while deleting record, and their dependents
  has_many :admins, dependent: :destroy

  #FIXME_AB: You should also have a association like has_one :owner/superadmin or a method to get company super admin/owner. Though you have save super_admin in the role column of admin. I think super admin is sitewide admin, means admin of cserve site. The person signing up for the company account is actually owner of the company so, we should have owner as the role

end
