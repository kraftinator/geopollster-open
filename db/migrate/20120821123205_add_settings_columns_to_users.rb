class AddSettingsColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_name, :string, :default => '', :null => false
    add_column :users, :email, :string, :null => false
    add_column :users, :public_profile, :boolean, :default => false, :null => false
    add_column :users, :connected_app_notify, :boolean, :default => true, :null => false
    add_column :users, :post_to_checkin, :boolean, :default => false, :null => false
    add_column :users, :email_notify, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :users, :email_notify
    remove_column :users, :post_to_checkin
    remove_column :users, :connected_app_notify
    remove_column :users, :public_profile
    remove_column :users, :email
    remove_column :users, :last_name
  end
end
