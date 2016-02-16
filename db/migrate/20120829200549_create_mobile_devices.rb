class CreateMobileDevices < ActiveRecord::Migration
  def self.up
    create_table :mobile_devices do |t|
      t.column :foursquare_name, :string, :limit => 50, :null => false
      t.column :display_name, :string, :limit => 50, :null => false
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :mobile_devices
  end
end
