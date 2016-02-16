class CreateGenders < ActiveRecord::Migration
  def self.up
    create_table :genders do |t|
      t.column :name, :string, :limit => 10, :null => false
      t.column :abbrev, :string, :limit => 1, :null => false
    end
  end

  def self.down
    drop_table :genders
  end
end
