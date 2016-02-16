class AddPartyToVenues < ActiveRecord::Migration
  def self.up
    add_column :venues, :party_id, :integer
  end

  def self.down
    remove_column :venues, :party_id
  end
end
