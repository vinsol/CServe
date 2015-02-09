class Article < ActiveRecord::Base

  include AASM

  belongs_to :company
  belongs_to :admin

  validates :title, :description, presence: :true

  aasm column: :state, whiny_transitions: false do
    state :draft, initial: true
  end

  def set_admin(admin)
    self.admin_id = admin.id
  end

end
