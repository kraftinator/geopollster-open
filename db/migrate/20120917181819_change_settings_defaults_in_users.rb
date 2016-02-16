class ChangeSettingsDefaultsInUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :post_to_checkin, :boolean, :default => true, :null => false
    change_column :users, :public_profile, :boolean, :default => true, :null => false
  end

  def self.down
    change_column :users, :post_to_checkin, :boolean, :default => false, :null => false
    change_column :users, :public_profile, :boolean, :default => false, :null => false
  end
end
