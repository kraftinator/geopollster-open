namespace :test do
  
  desc 'Generate fake check-in'
  task :create_checkin => :environment do
    
    if Rails.env == 'production'
      puts "Don't run this in production!!"
      exit
    end
    
    user_id = ENV['USER_ID']
    checkin_id = ENV['CHECKIN_ID']
    user = User.find( user_id )
    client = user.user_client
    checkin = client.checkin( checkin_id )
    
    country = Country.identify( checkin.venue.location.cc, checkin.venue.location.country )
    
    ## Create checkin hash
    c = {}
    c[:id] = checkin['id'] ## checkin foursquare id
    c[:created_at] = checkin['createdAt']
    c[:venue_id] = checkin['venue']['id'] ## venue foursquare id
    c[:venue_name] = checkin['venue']['name'] ## venue foursquare name
    c[:venue_categories] = checkin['venue']['categories'] ## venue foursquare categories
    c[:venue_location_lat] = checkin['venue']['location']['lat'] ## latitude
    c[:venue_location_lng] = checkin['venue']['location']['lng'] ## longitude
    vote = Vote.generate( c, country, user )
    
    puts "vote.id = #{vote.id.to_s}"
    
  end ## task
	
  desc 'Generate fake check-ins'
  task :create_checkins => :environment do
    
    if Rails.env == 'production'
      puts "Don't run this in production!!"
      exit
    end
    
    users = User.find( :all )
    users.each do |user|
      next unless user.party
      puts "Processing checkins for user id = #{ user.id }"
      client = CustomFoursquare::Client.new( :oauth_token => user.foursquare_access_token )
      client.ssl[:ca_path]= "/etc/ssl/certs"
      checkins = client.user_checkins( :limit => 100 )
      checkins.items.each do |checkin|
      
        
        country = Country.identify( checkin.venue.location.cc, checkin.venue.location.country )
    
        ## Create checkin hash
        c = {}
        c[:id] = checkin['id'] ## checkin foursquare id
        c[:created_at] = checkin['createdAt']
        c[:venue_id] = checkin['venue']['id'] ## venue foursquare id
        c[:venue_name] = checkin['venue']['name'] ## venue foursquare name
        c[:venue_categories] = checkin['venue']['categories'] ## venue foursquare categories
        c[:venue_location_lat] = checkin['venue']['location']['lat'] ## latitude
        c[:venue_location_lng] = checkin['venue']['location']['lng'] ## longitude
        c[:source_name] = checkin['source']['name']
        vote = Vote.generate( c, country, user )
    
        if vote
          #puts "vote.id = #{vote.id.to_s}"
        else
          #puts checkin
        end
=begin
        if checkin
          if checkin.venue.country.code == 'US'
            if !checkin.vote
              vote = Vote.create(
                  :checkin => checkin,
                  :party => user.party,
                  :gender => user.gender,
                  :mobile_device => MobileDevice.identify( c.source.name )
              )
              puts "Created vote for #{ vote.checkin.venue.name }"
            end ## does checkin have associated vote?
          end ## checkin in the US?
        else
          ## Validate venue exists
          next unless c.venue
          ## Is venue in United States?
          country = Country.identify( c.venue.location.cc, c.venue.location.country )
          if country.code == 'US'
            ## Does venue already exist?
            venue = Venue.find_by_foursquare_guid( c.venue.id )
            if venue
              #TODO
            else
              ## Validate primary category
              category = Category.identify( c.venue.categories )
              next unless category
              ## Get zip code
              zip_code = ZipCode.identify( c.venue.location.lat, c.venue.location.lng )
              next unless zip_code
              ## Create venue
              venue = Venue.create(
                  :foursquare_guid => c.venue.id,
                  :name => c.venue.name,
                  :company => Company.identify( c.venue.name ),
                  :zip_code => zip_code,
                  :country => country
              )
              ## Create checkin
              checkin = Checkin.create(
                  :foursquare_guid => c.id,
                  :user => user,
                  :venue => venue,
                  :checked_in_at => Time.at( c.createdAt )
              )
              ## Create vote
              vote = Vote.create(
                  :checkin => checkin,
                  :party => user.party,
                  :gender => user.gender,
                  :mobile_device => MobileDevice.identify( c.source.name )
              )
              ## Create power change
              power_change = PowerChange.create( :object => venue, :winning_party => user.party )
              puts "Created vote for #{ venue.name }"
            end ## venue?
          end ## in USA?
            
        end ## does checkin already exist?
=end
      end ## checkins
    end ## users
    
  end ## task
  
end ## namespace