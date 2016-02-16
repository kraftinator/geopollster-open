class Category < ActiveRecord::Base

  belongs_to :party
  has_many :venues
  
  default_scope :order => 'display_name asc'
  named_scope :top_level, :conditions => ["parent_id is null"], :order => 'display_name'
  
  def self.identify( foursquare_categories )
=begin
    return nil unless foursquare_categories
    primary = nil
    foursquare_categories.each do |cat|
      primary = cat if cat.primary and cat.primary?
      next if primary
    end
    return primary if !primary
    self.find_by_foursquare_guid_and_eligible( primary.id, true )
=end
    return nil unless foursquare_categories
    primary = nil
    foursquare_categories.each do |cat|
      primary = cat if cat['primary'] and cat['primary'] == true
      next if primary
    end
    return primary if !primary
    self.find_by_foursquare_guid_and_eligible( primary['id'], true )

  end
  
  def children
    Category.find_all_by_parent_id_and_eligible( self.id, true )
  end
  
  def polling( cache=true )
    if cache
      VoteCount.cached_polling( self )
    else
      Vote.polling( self )
    end
  end
  
end
