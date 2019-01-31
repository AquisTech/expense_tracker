# To set delivery method for mail
ActionMailer::Base.delivery_method = :smtp

# Set credentials for smtp
ActionMailer::Base.smtp_settings = {
  address:              'smtp.gmail.com',
  port:                 587,
  domain:               'example.com',
  user_name:            ENV['SMTP_EMAIL'],
  password:             ENV['SMTP_PASSWORD'],
  authentication:       'plain',
  enable_starttls_auto: true
}

ActionMailer::Base.perform_deliveries = true