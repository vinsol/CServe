module SubdomainHelper

  def host_with(subdomain)
    [subdomain, Rails.application.config.action_mailer.default_url_options[:host]].join('.')
  end

end
