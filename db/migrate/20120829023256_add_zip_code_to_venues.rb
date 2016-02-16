class AddZipCodeToVenues < ActiveRecord::Migration
  def self.up
    add_column :venues, :zip_code_id, :integer, :null => true
  end

  def self.down
    remove_column :venues, :zip_code_id
  end
end
