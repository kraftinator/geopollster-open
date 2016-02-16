class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      t.column :foursquare_guid, :string, :null => false
      t.column :name, :string, :null => false
      t.column :company_id, :integer, :null => true
      t.column :country_id, :integer, :null => false
      t.column :category_id, :integer, :null => true
    end
  end

  def self.down
    drop_table :venues
  end
end
