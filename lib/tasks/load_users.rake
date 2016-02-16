require 'custom_foursquare'

namespace :load_users do
	
  desc 'Load users'
  task :build => :environment do
    client = CustomFoursquare::Client.new( :oauth_token => ENV['FOURSQUARE_OAUTH'] )
		filename = 'lib/tasks/import/users.csv'
		#CSV.foreach( filename, {:headers => false} ) do |row|
		CSV.open( filename, "r") do |row|
			## Get fields
			foursquare_guid = row[0]
			party_id = row[1]
			access_token = row[2]
			## Validate party
			party_id = nil if party_id == 0
			## Validate with Foursquare
			f = client.user( foursquare_guid )
			next if !f
			## Does user exist?
			user = User.find_by_foursquare_guid( f.id )
			next if user
      # Create new user
      access_token = "UNKNOWN" if access_token.blank?
      user = User.new( 
      		:foursquare_guid => f.id,
      		:foursquare_access_token => access_token,
      		:first_name => f.firstName,
      		:last_name => f.lastName ? f.lastName : '',
      		:last_login => nil,
      		:gender => Gender.convert_foursquare_gender( f.gender ),
      		:photo_url => f.photo,
      		:email => f.contact.email,
      		:public_profile => false,
      		:connected_app_notify => false,
      		:post_to_checkin => false,
      		:email_notify => false,
      		:active => false,
      		:party_id => party_id
      )
      user.save
			## Output
			puts "created user #{ user.first_name } #{ user.last_name }"
			exit
	  end
  end
 
end