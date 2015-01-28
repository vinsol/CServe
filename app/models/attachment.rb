class Attachment < ActiveRecord::Base

  has_attached_file :document

  belongs_to :ticket

  validates_attachment :document,
    content_type: { content_type: %w(image/jpeg image/jpg image/png application/pdf
      application/vnd.openxmlformats-officedocument.wordprocessingml.document application/mspowerpoint
      application/vnd.ms-powerpoint application/vnd.openxmlformats-officedocument.presentationml.presentation) },
    size: { less_than: 2.megabyte }
end