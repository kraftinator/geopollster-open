class Vote < ActiveRecord::Base

  belongs_to :checkin
  belongs_to :gender
  belongs_to :mobile_device
  belongs_to :party
  
  def after_create
    if self.checkin.venue.zip_code and self.checkin.venue.category
      if self.checkin.venue.party
        ruling_party_id = Vote.ruling_party( self.checkin.venue )
        if ruling_party_id != self.checkin.venue.party.id
          PowerChange.create( :object => self.checkin.venue, :winning_party_id => ruling_party_id, :losing_party => self.checkin.venue.party )
          self.checkin.venue.update_attribute( :party_id, ruling_party_id )
        end
      else
        self.checkin.venue.update_attribute( :party, self.party )
        PowerChange.create( :object => self.checkin.venue, :winning_party => self.party )
      end      
    end
  end
  
  ## Voter fraud?
  def self.is_fake?( venue, user )
    previous_vote = self.find( 
        :first, 
        :conditions => ["votes.checkin_id = checkins.id and checkins.venue_id = ? and checkins.user_id = ?", venue.id, user.id],
        :joins => ", checkins", 
        :order => "votes.created_at desc" 
    )
    if previous_vote and previous_vote.created_at.to_date == Date.current
      return true
    else
      return false
    end
  end
  
  ## Generate vote object and dependent objects.
  ## Input parameter is hash:
  ##
  ## c[:id] = push_checkin['id'] ## checkin foursquare id
  ## c[:created_at] = push_checkin['createdAt']
  ## c[:source_name] = push['source']['name']
  ## c[:venue_id] = push_checkin['venue']['id'] ## venue foursquare id
  ## c[:venue_name] = push_checkin['venue']['name'] ## venue foursquare name
  ## c[:venue_categories] = push_checkin['venue']['categories'] ## venue foursquare categories
  ## c[:venue_location_lat] = push_checkin['venue']['location']['lat'] ## latitude
  ## c[:venue_location_lng] = push_checkin['venue']['location']['lng'] ## longitude
  ##
  def self.generate( c, country, user )
    return nil unless user.voter and country.usa
    checkin = Checkin.find_by_foursquare_guid( c[:id] )
    if checkin
      if checkin.vote
        ## Vote already exists. Return vote.
        return checkin.vote
      else
        ## Voter fraud?
        return nil if Vote.is_fake?( checkin.venue, checkin.user )
        ## Get source name
        c[:source_name] = Checkin.source_name( c[:id], user ) if !c[:source_name]
        ## Create vote
        vote = self.create(
           :checkin => checkin,
           :party => user.party,
           :gender => user.gender,
           :mobile_device => MobileDevice.identify( c[:source_name] )
        )
        ## Return vote
        return vote
      end
    else
      ## Create new checkin
      venue = Venue.find_by_foursquare_guid( c[:venue_id] )
      if venue
        ## Update venue location, if necessary
        if venue.country.usa and !venue.zip_code
          ## Get zip code
          zip_code = ZipCode.identify( c[:venue_location_lat], c[:venue_location_lng] )
          return nil unless zip_code
          venue.update_attribute( :zip_code, zip_code )
        end
        ## Voter fraud?
        return nil if Vote.is_fake?( venue, user )
        ## Create checkin
        checkin = Checkin.create(
            :foursquare_guid => c[:id],
            :user => user,
            :venue => venue,
            :checked_in_at => Time.at( c[:created_at] )
        )
        ## Get source name
        c[:source_name] = Checkin.source_name( c[:id], user ) if !c[:source_name]
        ## Create vote
        vote = self.create(
            :checkin => checkin,
            :party => user.party,
            :gender => user.gender,
            :mobile_device => MobileDevice.identify( c[:source_name] )
        )
        ## Return vote
        return vote
      else  
        ## Validate primary category
        category = Category.identify( c[:venue_categories] )
        return nil unless category
        ## Get zip code
        zip_code = ZipCode.identify( c[:venue_location_lat], c[:venue_location_lng] )
        return nil unless zip_code
        ## Create venue
        venue = Venue.create(
           :foursquare_guid => c[:venue_id],
           :name => c[:venue_name],
           :company => Company.identify( c[:venue_name] ),
           :category => category,
           :zip_code => zip_code,
           :country => country
        )
        ## Create checkin
        checkin = Checkin.create(
            :foursquare_guid => c[:id],
            :user => user,
            :venue => venue,
            :checked_in_at => Time.at( c[:created_at] )
        )
        ## Get source name
        c[:source_name] = Checkin.source_name( c[:id], user ) if !c[:source_name] 
        ## Create vote
        vote = self.create(
            :checkin => checkin,
            :party => user.party,
            :gender => user.gender,
            :mobile_device => MobileDevice.identify( c[:source_name] )
        )
        ## Return vote
        return vote
      end
    end

  end ## generate

  def self.ruling_party( object )
    find_ruling_party( object.party_id, self.polling( object ) )
  end
  
  def self.polling( object )

    ## Venue 
    if object.instance_of? Venue
         
      self.find( :all, 
          :conditions => ["votes.checkin_id = checkins.id and votes.created_at > ? and checkins.venue_id = ?", self.duration, object.id], 
          :select => 'votes.party_id, count(*) as total', 
          :joins => ', checkins',
          :group => 'votes.party_id', 
          :order => 'total desc' 
      )
      
    ## Zip Code
    elsif object.instance_of? ZipCode
      
      self.find( :all, 
          :conditions => ["votes.created_at > ? and votes.checkin_id = checkins.id and checkins.venue_id = venues.id and venues.zip_code_id = ?", self.duration, object.id], 
          :select => 'votes.party_id, count(*) as total',
          :joins => ', checkins, venues',
          :group => 'party_id', 
          :order => 'total desc'
      )
    
    ## City
    elsif object.instance_of? City
      
      self.find( :all, 
          :conditions => ["votes.created_at > ? and votes.checkin_id = checkins.id and checkins.venue_id = venues.id and venues.zip_code_id = zip_codes.id and zip_codes.city_id = ?", self.duration, object.id], 
          :select => 'votes.party_id, count(*) as total',
          :joins => ', checkins, venues, zip_codes',
          :group => 'party_id', 
          :order => 'total desc'
      )
       
    ## State
    elsif object.instance_of? State
      
      self.find( :all, 
          :conditions => ["votes.created_at > ? and votes.checkin_id = checkins.id and checkins.venue_id = venues.id and venues.zip_code_id = zip_codes.id and zip_codes.city_id = cities.id and cities.state_id = ?", self.duration, object.id], 
          :select => 'votes.party_id, count(*) as total',
          :joins => ', checkins, venues, zip_codes, cities',
          :group => 'party_id', 
          :order => 'total desc'
      )
         
    ## Country
    elsif object.instance_of? Country
      
      self.find( :all, 
          :conditions => ["votes.created_at > ? and votes.checkin_id = checkins.id and checkins.venue_id = venues.id and venues.zip_code_id = zip_codes.id and zip_codes.city_id = cities.id and cities.state_id = states.id and states.country_id = ?", self.duration, object.id], 
          :select => 'votes.party_id, count(*) as total',
          :joins => ', checkins, venues, zip_codes, cities, states',
          :group => 'party_id', 
          :order => 'total desc'
      )
      
    ## Category
    elsif object.instance_of? Category
      
      self.find( :all, 
          :conditions => ["votes.created_at > ? and votes.checkin_id = checkins.id and checkins.venue_id = venues.id and venues.category_id = ?", self.duration, object.id], 
          :select => 'votes.party_id, count(*) as total',
          :joins => ', checkins, venues',
          :group => 'party_id', 
          :order => 'total desc'
      )
      
    ## Gender
    elsif object.instance_of? Gender
      
      self.find( :all, 
          :conditions => ["votes.created_at > ? and votes.gender_id = ?", self.duration, object.id], 
          :select => 'votes.party_id, count(*) as total',
          :group => 'party_id', 
          :order => 'total desc'
      )
      
    ## Mobile Device
    elsif object.instance_of? MobileDevice
      
      self.find( :all, 
          :conditions => ["votes.created_at > ? and votes.mobile_device_id = ?", self.duration, object.id], 
          :select => 'votes.party_id, count(*) as total',
          :group => 'party_id', 
          :order => 'total desc'
      )
               
    end
    
  end
  
  ## How far back to count votes
  def self.duration
    1.month.ago
  end

  private
  
  # get ruling party
  def self.find_ruling_party( current_party_id, results )
    winning_party = results[0]
    return winning_party.party_id if winning_party.party_id.to_i == current_party_id.to_i
    current_ruling_party = nil
    results.each do |result|
      if result.party_id.to_i == current_party_id.to_i
        current_ruling_party = result
        next
      end
    end
    if current_ruling_party
      return current_ruling_party.party_id if current_ruling_party.total.to_i >= winning_party.total.to_i
    end
    winning_party.party_id
  end
  
end
