class CreatePoints < ActiveRecord::Migration
  def self.up
    create_table :points do |t|
      t.column :user_id, :integer, :null => false
      t.column :dem_total, :integer, :default => 0, :null => false
      t.column :rep_total, :integer, :default => 0, :null => false
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :points
  end
end
