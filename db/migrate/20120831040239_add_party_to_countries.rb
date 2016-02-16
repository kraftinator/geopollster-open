class AddPartyToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :party_id, :integer
  end

  def self.down
    remove_column :countries, :party_id
  end
end
