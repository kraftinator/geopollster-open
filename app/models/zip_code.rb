include Geokit::Geocoders

class ZipCode < ActiveRecord::Base

  belongs_to :city
  has_many :users
  has_many :venues
  
  default_scope :order => 'name asc'
  
  def self.identify( lat, lng )
    ##Get location data from google
    res = GoogleGeocoder.reverse_geocode( [lat, lng] )
    return nil unless res.zip
    ##Does zip code already exist?
    zip_code = self.find_by_name( res.zip )
    return zip_code if zip_code
    ##Create new location
    ##Get state
    state = State.find_by_abbrev( res.state )
    return nil unless state
    ##Get city
    return nil unless res.city
    city = City.find_by_name_and_state_id( res.city, state.id )
    if !city
      city = City.create( :name => res.city, :state => state )
    end
    ##Create new zip code
    self.create( :name => res.zip, :city => city )
  end
  
  def polling
    Vote.polling( self )
  end
  
end
