class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
    	t.column :name, :string, :limit => 50, :null => false
    	t.column :short_name, :string, :limit => 50, :null => false
    	t.column :twitter_handle, :string, :limit => 16
    	t.column :url, :string, :limit => 50
			t.column :sunlight_guid, :string
			t.column :url_slug, :string, :limit => 50, :null => false
    end
  end

  def self.down
    drop_table :companies
  end
end
