class CreateFriendCheckins < ActiveRecord::Migration
  def self.up
    create_table :friend_checkins do |t|
      t.column :foursquare_checkin_guid, :string, :null => false
      t.column :foursquare_user_guid, :string, :null => false
      t.column :first_name, :string, :null => false
      t.column :last_name, :string, :null => false
      t.column :photo_url, :string, :null => true
      t.column :twitter_handle, :string, :limit => 15, :null => true
      t.column :facebook_guid, :string, :null => true
      t.column :venue_id, :integer, :null => true
      t.column :venue_name, :string, :null => true
      t.column :company_id, :integer, :null => true
      t.column :user_id, :integer, :null => false
      t.column :checked_in_at, :datetime
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :friend_checkins
  end
end
