require 'mailman'

require "#{File.dirname __FILE__}/../config/environment"

Mailman.config.poll_interval = 3
Mailman.config.imap = {
  server: 'imap.gmail.com',
  port: 993,
  ssl: true,
  username: Rails.application.secrets.gmail_user_name,
  password: Rails.application.secrets.password
}

Mailman::Application.run do
  subject(/\[(.+)\] \(#(\d+)\) (.+)/) do |company_name, ticket_id, ticket_subject|
    if message.multipart?
      email_text = message.text_part.body.decoded
    else
      email_text = message.body.decoded
    end    
    Ticket.find_ticket_and_create_comment(company_name, ticket_id, ticket_subject, email_text, message)
  end

  subject(/^\(#(\d+)\) (.+) from (.+)/) do |code, subject, email_id|
    NotifierMailer.forward_confirmation_instructions(code, subject, email_id).deliver
  end

  default do
    if message.multipart?
      email_text = message.text_part.body.decoded
      ticket = Ticket.create_ticket_from_mail(email_text, message)
      message.attachments.each do |attachment|
        file = StringIO.new(attachment.decoded)
        file.class.class_eval { attr_accessor :original_filename, :content_type }
        file.original_filename = attachment.filename
        file.content_type = attachment.mime_type
        attached_file = ticket.attachments.build
        attached_file.document = file
      end
      ticket.save
    else
      email_text = message.body.decoded
      Ticket.create_ticket_from_mail(email_text, message)
    end
  end
end
