class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.column :name, :string, :limit => 50, :null => false
      t.column :state_id, :integer, :null => false
      t.column :party_id, :integer, :null => true
    end
  end

  def self.down
    drop_table :cities
  end
end
