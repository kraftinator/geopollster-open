class User < ActiveRecord::Base

  RE_EMAIL_NAME   = '[\w\.%\+\-]+'
  RE_DOMAIN_HEAD  = '(?:[A-Z0-9\-]+\.)+'
  RE_DOMAIN_TLD   = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'
  RE_EMAIL_OK     = /\A#{RE_EMAIL_NAME}@#{RE_DOMAIN_HEAD}#{RE_DOMAIN_TLD}\z/i

  belongs_to :gender
  belongs_to :country
  belongs_to :party
  belongs_to :zip_code
  has_many :cached_checkins
  has_many :cached_friends
  has_many :checkins, :order => 'checked_in_at desc'
  has_many :friend_checkins
  has_one :point
  
  validates_presence_of :first_name, :message => "First name cannot be blank."
  validates_length_of :first_name, :within => 1..50, :message => "First name cannot exceed 50 characters."
  validates_length_of :last_name, :within => 0..50, :message => "Last name cannot exceed 50 characters."
  
  #validates_presence_of :email, :message => "Email address cannot be blank."
  #validates_length_of :email, :within => 6..100, :message => "Email must be at least 6 characters."
  #validates_uniqueness_of :email, :case_sensitive => false, :message => "Email address is already in use."
  #validates_format_of :email, :with => RE_EMAIL_OK, :message => "Valid email address is required."
  
  def before_update
    if !self.party
      self.party_id = nil
    end
  end
  
  def before_create
    if !self.party
      self.party_id = nil
    end
    
  end
  
  def after_create
    Point.create( :user => self )
  end
  
  ## Delete cached data
  def clear_cache
    self.cached_checkins.destroy_all if self.cached_checkins.any?
    self.friend_checkins.destroy_all if self.friend_checkins.any?
    self.cached_friends.destroy_all if self.cached_friends.any?
  end
  
  def voter
    party and !deleted_at
  end
  
  def twitter_connect?
    return true if twitter_oauth_token and twitter_oauth_secret
    false
  end
  
  def display_name
    if last_name and !last_name.blank?
      return "#{ first_name } #{ last_name.first }."
    else
      return first_name
    end
  end
  
  def full_name
    if last_name
      return "#{ first_name } #{ last_name }"
    else
      return first_name
    end
  end
  
  def location
    if zip_code
      zip_code.city.full_name
    elsif country
      country.name
    else
      ''
    end
  end
  
  def user_client
    client = CustomFoursquare::Client.new( :oauth_token => foursquare_access_token )
    client.ssl[:ca_path]= "/etc/ssl/certs"
    client
  end
  
  def twitter_client
    Twitter::Client.new( :oauth_token => twitter_oauth_token, :oauth_token_secret => twitter_oauth_secret )
  end
  
  ## Analyze checkin history and set cache.
	def set_checkin_history( client )
	
	  ## Delete existing cached checkins
	  self.cached_checkins.destroy_all
	  
  	checkins = client.user_checkins( :limit => 250 )
  	checkins.items.each do |c|
  	  
  	  ## Don't process private check-ins
  	  next if c.private
  	  
  	  checkin = Checkin.find_by_foursquare_guid( c.id )
  	  if checkin
  	    ## Checkin already exists. Do nothing.
  	  else
  	    if c.venue
          venue = Venue.find_by_foursquare_guid( c.venue.id )
          if venue
            if venue.company
              ## Create checkin
              checkin = Checkin.create(
                  :foursquare_guid => c.id,
                  :user => self,
                  :venue => venue,
                  :checked_in_at => Time.at( c.createdAt )
              )
            else
              ## No associated company. Create cached checkin.
              cached_checkin = CachedCheckin.create(
                  :foursquare_guid => c.id,
                  :user => self,
                  :venue => venue,
                  :checked_in_at => Time.at( c.createdAt )
              )
            end
          else
            company = Company.identify( c.venue.name )
            if company
              ## Excellent! Create new venue and new checkin.
              country = Country.identify( c.venue.location.cc, c.venue.location.country )
              #country = Country.find_by_code( c.venue.location.cc )
              ## Create country, if necessary
              #if !country
              #  country = Country.create(
              #      :code => c.venue.location.cc,
              #      :name => c.venue.location.country
              #  )
              #end
              ## Create venue
              venue = Venue.create(
                  :foursquare_guid => c.venue.id,
                  :name => c.venue.name,
                  :company => company,
                  :category => Category.identify( c.venue.categories ),
                  #:zip_code => country.usa ? ZipCode.identify( c.venue.location.lat, c.venue.location.lng ) : nil,
                  :country => country
              )
              ## Create checkin
              checkin = Checkin.create(
                  :foursquare_guid => c.id,
                  :user => self,
                  :venue => venue,
                  :checked_in_at => Time.at( c.createdAt )
              )
            else
              ## No venue and no company. Create cached checkin.
              cached_checkin = CachedCheckin.create(
                  :foursquare_guid => c.id,
                  :user => self,
                  :venue_name => c.venue.name,
                  :checked_in_at => Time.at( c.createdAt )
              )
              
            end
          end
        end
  	  end
  	  
  	end ## end loop
  	
  	calculate_points

	end ## end method
	
	## Build array of recent checkins
	def recent_checkins
	  [self.checkins,self.cached_checkins].flatten.sort! { |a,b| b.checked_in_at <=> a.checked_in_at }
	end
	
	def set_friend_checkins( client )
	
	  ## Delete existing friend checkins
	  self.friend_checkins.destroy_all if self.friend_checkins.any?
	
  	checkins = client.recent_checkins
  	checkins.each do |c|
  	  next if c.user.id == self.foursquare_guid
  	  next if c.user.relationship and c.user.relationship != 'friend'
  	  next unless c.venue and c.venue.name
  	  venue = Venue.find_by_foursquare_guid( c.venue.id )
  	  
  	  user = User.find_by_foursquare_guid( c.user.id )
  	  if user
  	    first_name = user.first_name
  	    last_name = user.last_name
  	  else
  	    first_name = c.user.firstName ? c.user.firstName : ''
  	    last_name = c.user.lastName ? c.user.lastName : ''
  	  end
  	  
  	  friend_checkin = FriendCheckin.create(
  	    :foursquare_checkin_guid => c.id,
  	    :foursquare_user_guid => c.user.id,
  	    #:first_name => c.user.firstName ? c.user.firstName : '',
  	    #:last_name => c.user.lastName ? c.user.lastName : '',
  	    :first_name => first_name,
  	    :last_name => last_name,
  	    :photo_url => c.user.photo,
  	    :twitter_handle => c.user.twitter,
  	    :facebook_guid => c.user.facebook,
  	    :venue => venue,
  	    :venue_name => venue ? nil : c.venue.name,
  	    :company => venue ? venue.company : Company.identify( c.venue.name ),
  	    :user => self,
  	    :checked_in_at => Time.at( c.createdAt )
  	  )
  	end ## end loop
 	
	end
	
	def calculate_points
	  if self.point
	    self.point.calculate
	  else
	    point = Point.create( :user => self )
	    point.calculate
	  end
	end
	
	def self.users_by_party( party )
		VoteCount.find( :all,
        :select => 'genders.abbrev as gender, total',
        :conditions => [ "object_type = 'Gender' and object_id = genders.id and party_id = ? and total > 0", party.id ],
        :joins => ', genders',
        :group => 'gender',
        :order => 'total desc' )
  end
  
end
