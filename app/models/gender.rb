class Gender < ActiveRecord::Base

  has_many :cached_friends
  has_many :users
  has_many :votes

  ## Convert Foursquare gender string to GeoPollster Gender object
  def self.convert_foursquare_gender( foursquare_gender )
    return self.find_by_abbrev( 'M' ) if foursquare_gender == 'male'
    return self.find_by_abbrev( 'F' ) if foursquare_gender == 'female'
    self.find_by_abbrev( 'U' )
  end

  def object_pronoun
    return 'him' if self.abbrev == 'M'
    return 'her' if self.abbrev == 'F'
    return 'them'
  end
  
  def possessive_pronoun
    return 'his' if self.abbrev == 'M'
    return 'her' if self.abbrev == 'F'
    return 'their'
  end
  
  def polling( cache=true )
    if cache
      VoteCount.cached_polling( self )
    else
      Vote.polling( self )
    end
  end
  
end
