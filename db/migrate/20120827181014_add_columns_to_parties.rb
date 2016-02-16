class AddColumnsToParties < ActiveRecord::Migration
  def self.up
    add_column :parties, :official_name, :string, :limit => 50, :null => false
    add_column :parties, :member_name, :string, :limit => 50, :null => false
    add_column :parties, :member_name_plural, :string, :limit => 50, :null => false
    add_column :parties, :icon_url, :string, :limit => 100, :default => '', :null => false
    add_column :parties, :description, :string, :limit => 500, :default => ''
    add_column :parties, :official_url, :string, :limit => 100, :default => ''
    add_column :parties, :facebook_url, :string, :limit => 100, :default => ''
    add_column :parties, :twitter_url, :string, :limit => 100, :default => ''
    add_column :parties, :youtube_url, :string, :limit => 100, :default => ''
    add_column :parties, :wikipedia_url, :string, :limit => 100, :default => ''
    add_column :parties, :url_slug, :string, :limit => 40, :null => false
  end

  def self.down
    remove_column :parties, :url_slug
    remove_column :parties, :wikipedia_url
    remove_column :parties, :youtube_url
    remove_column :parties, :twitter_url
    remove_column :parties, :facebook_url
    remove_column :parties, :official_url
    remove_column :parties, :description
    remove_column :parties, :icon_url
    remove_column :parties, :member_name_plural
    remove_column :parties, :member_name
    remove_column :parties, :official_name
  end
end
