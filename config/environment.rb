# Load the rails application
require File.expand_path('../application', __FILE__)

config.action_mailer.raise_delivery_errors = true

config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => 'gnibl.com',
  :user_name            => 'gniblteam',
  :password             => 'gnibl2013',
  :authentication       => 'plain',
  :enable_starttls_auto => true  }
config.action_mailer.default_url_options = {
    :host => 'localhost:3000',
    :only_path => false
}

# Initialize the rails application
Gnibl::Application.initialize!
