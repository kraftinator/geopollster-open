class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :foursquare_guid, :string
      t.column :name, :string, :limit => 50, :null => false
      t.column :display_name, :string, :limit => 50, :null => false
      t.column :icon_url, :string, :limit => 100, :null => false
      t.column :parent_id, :integer
      t.column :eligible, :boolean, :default => true, :null => false
      t.column :notify, :boolean, :default => true, :null => false
      t.column :party_id, :integer
      t.column :url_slug, :string, :limit => 50, :null => false
    end
  end

  def self.down
    drop_table :categories
  end
end
