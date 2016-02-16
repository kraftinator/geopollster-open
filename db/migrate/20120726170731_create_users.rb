class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :foursquare_guid, :string, :null => false
      t.column :foursquare_access_token, :string, :null => false
      t.column :first_name, :string, :null => false
      t.column :last_login, :datetime
      t.column :deleted_at, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
