require 'custom_foursquare'

if Rails.env == 'production'
  APP_FOURSQUARE_GUID = ENV['FOURSQUARE_GUID_PRODUCTION']
elsif Rails.env == 'staging'
  APP_FOURSQUARE_GUID = ENV['FOURSQUARE_GUID_STAGING']
elsif Rails.env == 'development'
  APP_FOURSQUARE_GUID = ENV['FOURSQUARE_GUID_DEVELOPMENT']
else
  puts "Unknown environment"
  exit
end

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
client = CustomFoursquare::Client.new( :oauth_token => APP_FOURSQUARE_GUID )
client.ssl[:ca_path]= "/etc/ssl/certs"
checkins = client.recent_checkins
checkins = checkins.reverse

checkins.each do |checkin|
  user = User.find_by_foursquare_guid( checkin.user.id )
  next if !user
  if Rails.env == 'production'
    next unless user.foursquare_access_token == "UNKNOWN"
  end
  next unless checkin['source']
  next unless checkin['source']['name']
   
  country = Country.identify( checkin['venue']['location']['cc'], checkin['venue']['location']['country'] )
  if user.voter and country.usa and checkin['venue']
    c = {}
    c[:source_name] = checkin['source']['name']
    c[:id] = checkin['id'] ## checkin foursquare id
    c[:created_at] = checkin['createdAt']
    c[:venue_id] = checkin['venue']['id'] ## venue foursquare id
    c[:venue_name] = checkin['venue']['name'] ## venue foursquare name
    c[:venue_categories] = checkin['venue']['categories'] ## venue foursquare categories
    c[:venue_location_lat] = checkin['venue']['location']['lat'] ## latitude
    c[:venue_location_lng] = checkin['venue']['location']['lng'] ## longitude
    Vote.generate( c, country, user )
  end
        
end
