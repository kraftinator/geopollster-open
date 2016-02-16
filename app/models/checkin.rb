class Checkin < ActiveRecord::Base

  belongs_to :user
  belongs_to :venue
  has_one :vote
  
  def after_create
    self.user.update_attributes( :country => self.venue.country, :zip_code => self.venue.zip_code )
  end  
  
  def self.duplicate( foursquare_guid )
    if self.find_by_foursquare_guid( foursquare_guid )
      return true
    else
      return false
    end
  end
  
  def self.source_name( foursquare_guid, user )
    client = user.user_client
    foursquare_checkin = client.checkin( foursquare_guid )
    if foursquare_checkin and foursquare_checkin.source
      return foursquare_checkin.source.name
    else
      return nil
    end
  end
  
end
