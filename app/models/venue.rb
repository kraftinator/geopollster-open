class Venue < ActiveRecord::Base

  belongs_to :category
  belongs_to :company
  belongs_to :country
  belongs_to :party
  belongs_to :zip_code
  has_many :checkins
  has_many :cached_checkins
  has_many :friend_checkins
  has_many :power_changes, :as => :object
  has_many :votes, :through => :checkins
  
  delegate :city, :to => :zip_code
  
  def polling
    Vote.polling( self )
  end
  
end