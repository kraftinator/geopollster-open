class Country < ActiveRecord::Base

  belongs_to :party
  has_many :states
  has_many :users
  has_many :venues
  
  def self.identify( code, name )
    country = self.find_by_code( code, name )
    return country if country
    ##Create new country
    self.create( :code => code, :name => name )
  end
  
  def usa
    code == 'US'
  end
  
  def polling( cache=true )
    if cache
      VoteCount.cached_polling( self )
    else
      Vote.polling( self )
    end
  end
  
end
