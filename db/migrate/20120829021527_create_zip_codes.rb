class CreateZipCodes < ActiveRecord::Migration
  def self.up
    create_table :zip_codes do |t|
      t.column :name, :string, :limit => 5, :null => false
      t.column :city_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :zip_codes
  end
end
