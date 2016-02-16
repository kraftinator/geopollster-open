class RemovePluralNameFromParties < ActiveRecord::Migration
  def self.up
    remove_column :parties, :plural_name
  end

  def self.down
    add_column :parties, :plural_name, :string, :limit => 50, :null => false
  end
end
