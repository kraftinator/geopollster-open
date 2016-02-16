class AddPartyAndLocationsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :country_id, :integer
    add_column :users, :zip_code_id, :integer
    add_column :users, :party_id, :integer
  end

  def self.down
    remove_column :users, :party_id
    remove_column :users, :zip_code_id
    remove_column :users, :country_id
  end
end
