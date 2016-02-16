class CreateCachedFriends < ActiveRecord::Migration
  def self.up
    create_table :cached_friends do |t|
      t.column :user_id, :integer, :null => false
      t.column :foursquare_guid, :string, :null => false
      t.column :last_checkin_guid, :string, :null => true
      t.column :twitter_handle, :string, :limit => 15, :null => true
      t.column :first_name, :string, :null => false
      t.column :last_name, :string, :null => false
      t.column :photo_url, :string, :null => true
      t.column :gender_id, :integer, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :cached_friends
  end
end
