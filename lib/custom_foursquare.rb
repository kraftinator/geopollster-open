require 'faraday'
require 'faraday_middleware'

directory = File.expand_path(File.dirname(__FILE__))

module CustomFoursquare
  class << self

    def filter tips, term
      tip = []
      unless tips.nil?
        tips.items.each do |check_tip|
          tip << check_tip if check_tip.text.downcase.include? term.downcase
        end
      end
      Hashie::Mash.new({:count => tip.count, :items => tip })
    end

  end

  require 'custom_foursquare/campaigns'
  require 'custom_foursquare/users'
  require 'custom_foursquare/specials'
  require 'custom_foursquare/settings'
  require 'custom_foursquare/photos'
  require 'custom_foursquare/tips'
  require 'custom_foursquare/checkins'
  require 'custom_foursquare/venues'
  require 'custom_foursquare/pages'
  require 'custom_foursquare/lists'
  require 'custom_foursquare/client'
  require 'custom_foursquare/api_error'


end

