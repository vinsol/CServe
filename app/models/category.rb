class Category < ActiveRecord::Base

  validates :name, presence: true, uniqueness: { scope: :company_id,
    message: 'already exists', case_sensitive: false }


  has_many :articles, through: :articles_categories
  has_many :articles_categories

end
