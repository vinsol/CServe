class Attachment < ActiveRecord::Base

  has_attached_file :document,
                    style: { thumb: '100x100' },
                    url: '/system/:class/:attachment/:id/:style/:basename.:extension',
                    path: 'public/system/:class/:attachment/:id/:style/:basename.:extension'

  belongs_to :ticket

  validates_attachment :document,
    content_type: { content_type: %w(image/jpeg image/jpg image/png) },
    size: { less_than: 2.megabyte }
end
