class City < ActiveRecord::Base

  belongs_to :party
  belongs_to :state
  has_many :zip_codes
  
  default_scope :order => 'name asc'
  
  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}-#{state.abbrev.gsub(/[^a-z0-9]+/i, '-')}"
  end
  
  def full_name
    "#{ name }, #{ state.abbrev }"
  end
  
  def polling
    Vote.polling( self )
  end
  
end
