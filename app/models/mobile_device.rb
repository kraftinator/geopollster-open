class MobileDevice < ActiveRecord::Base

  has_many :votes
  
  def self.identify( foursquare_name )
    mobile_device = self.find_by_foursquare_name( foursquare_name )
    return mobile_device if mobile_device
    ##Create new mobile device
    self.create( :foursquare_name => foursquare_name, :display_name => foursquare_name )
  end
  
  def polling( cache=true )
    if cache
      VoteCount.cached_polling( self )
    else
      Vote.polling( self )
    end
  end
  
end
