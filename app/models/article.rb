class Article < ActiveRecord::Base

  include AASM

  has_many :categories, through: :articles_categories
  has_many :articles_categories

  belongs_to :company
  belongs_to :admin

  validates :title, :description, :category_ids, presence: true
  validates :title, length: { maximum: 80 }

  delegate :name, to: :admin, prefix: true

  paginates_per 20

  scope :published, -> { where(state: :published) }

  aasm column: :state, whiny_transitions: false do
    state :draft, initial: true
    state :published
    state :unpublished

    event :publish do
      transitions from: [:draft, :unpublished], to: :published
    end

    event :unpublish do
      transitions from: :published, to: :unpublished
    end
  end

end
