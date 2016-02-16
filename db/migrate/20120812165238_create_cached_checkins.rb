class CreateCachedCheckins < ActiveRecord::Migration
  def self.up
    create_table :cached_checkins do |t|
      t.column :foursquare_guid, :string, :null => false
      t.column :user_id, :integer, :null => false
      t.column :venue_id, :integer, :null => true
      t.column :venue_name, :string, :null => true
      t.column :checked_in_at, :datetime
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :cached_checkins
  end
end
