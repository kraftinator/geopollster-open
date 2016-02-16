class AddTopCompaniesToPoints < ActiveRecord::Migration
  def self.up
    add_column :points, :dem_company_id, :integer, :null => true
    add_column :points, :rep_company_id, :integer, :null => true
  end

  def self.down
    remove_column :points, :rep_company_id
    remove_column :points, :dem_company_id
  end
end
