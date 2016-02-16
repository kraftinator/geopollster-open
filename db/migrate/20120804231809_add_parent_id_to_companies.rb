class AddParentIdToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :parent_id, :integer, :null => true
    change_column :companies, :twitter_handle, :string, :limit => 15
    change_column :companies, :short_name, :string, :limit => 50, :null => true
    change_column :companies, :url_slug, :string, :limit => 50, :null => true
  end

  def self.down
    remove_column :companies, :parent_id
    change_column :companies, :twitter_handle, :string, :limit => 16
    change_column :companies, :short_name, :string, :limit => 50, :null => false
    change_column :companies, :url_slug, :string, :limit => 50, :null => false
  end
end
