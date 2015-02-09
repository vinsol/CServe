class Attachment < ActiveRecord::Base

  has_attached_file :document

  #FIXME_AB: use require true to add validation
  belongs_to :ticket

  validates_attachment :document,
    content_type: { content_type: %w(image/jpeg image/jpg image/png
      application/vnd.openxmlformats-officedocument.wordprocessingml.document) },
    size: { less_than: 2.megabyte }
end