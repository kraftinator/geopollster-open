class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.column :name, :string, :limit => 30, :null => false
      t.column :abbrev, :string, :limit => 2, :null => false
      t.column :electoral_college, :integer, :default => 0
      t.column :country_id, :integer, :null => false
      t.column :party_id, :integer, :null => true
      t.column :url_slug, :string, :limit => 30, :null => false
    end
  end

  def self.down
    drop_table :states
  end
end
