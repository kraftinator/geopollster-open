class CreateParties < ActiveRecord::Migration
  def self.up
    create_table :parties do |t|
			t.column :name, :string, :limit => 50, :null => false
			t.column :plural_name, :string, :limit => 50, :null => false
    end
  end

  def self.down
    drop_table :parties
  end
end
