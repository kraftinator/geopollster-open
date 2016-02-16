class PowerChange < ActiveRecord::Base

  belongs_to :object, :polymorphic => true
  belongs_to :winning_party, :class_name=> 'Party', :foreign_key => 'winning_party_id'
  belongs_to :losing_party, :class_name=> 'Party', :foreign_key => 'losing_party_id'

  def self.recent( count, object = nil )
    
    ## City
    if object.instance_of? City
      self.find( :all, 
          :conditions => ["power_changes.created_at > ? and power_changes.object_type = 'Venue' and power_changes.object_id = venues.id and venues.zip_code_id = zip_codes.id and zip_codes.city_id = ?", Vote.duration, object.id], 
          :joins => ', venues, zip_codes',
          :order => 'power_changes.created_at desc',
          :limit => count 
      )
    ## State
    elsif object.instance_of? State
      self.find( :all, 
          :conditions => ["power_changes.created_at > ? and power_changes.object_type = 'Venue' and power_changes.object_id = venues.id and venues.zip_code_id = zip_codes.id and zip_codes.city_id = cities.id and cities.state_id = ?", Vote.duration, object.id], 
          :joins => ', venues, zip_codes, cities',
          :order => 'power_changes.created_at desc',
          :limit => count 
      )
    ## Zip Code
    elsif object.instance_of? ZipCode
      self.find( :all, 
          :conditions => ["power_changes.created_at > ? and power_changes.object_type = 'Venue' and power_changes.object_id = venues.id and venues.zip_code_id = ?", Vote.duration, object.id], 
          :joins => ', venues',
          :order => 'power_changes.created_at desc',
          :limit => count 
      )
    ## Category
    elsif object.instance_of? Category
      self.find( :all, 
          :conditions => ["power_changes.created_at > ? and power_changes.object_type = 'Venue' and power_changes.object_id = venues.id and venues.category_id = ?", Vote.duration, object.id], 
          :joins => ', venues',
          :order => 'power_changes.created_at desc',
          :limit => count 
      )
    else
      ## No filter
      self.find( :all, :order => 'created_at desc', :limit => count )
    end

  end

end
