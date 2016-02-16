class CreateCheckins < ActiveRecord::Migration
  def self.up
    create_table :checkins do |t|
      t.column :foursquare_guid, :string, :null => false
      t.column :user_id, :integer, :null => false
      t.column :venue_id, :integer, :null => false
      t.column :checked_in_at, :datetime
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :checkins
  end
end
