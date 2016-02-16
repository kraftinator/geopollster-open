Geopollster::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  # Constants
  FOURSQUARE_CONSUMER_KEY = ENV['FOURSQUARE_CONSUMER_KEY']
  FOURSQUARE_CONSUMER_SECRET = ENV['FOURSQUARE_CONSUMER_SECRET']
	SUNLIGHT_API_KEY = ENV['SUNLIGHT_API_KEY']
	SITE_URL = 'http://gp-canada.railsplayground.net'
	APP_URL = "https://foursquare.com/app/geopollster/IRKXVACINCMFPJCS5MNM0OSWZFFCCNLNOQXM3QKO4WTY4YGA"
	
	Twitter.configure do |config|
    config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  end
  
end

