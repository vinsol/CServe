class ApplicationMailer < ActionMailer::Base

  helper :subdomain
  default from: 'CServe <akshay.chhikara@vinsol.com>'

end