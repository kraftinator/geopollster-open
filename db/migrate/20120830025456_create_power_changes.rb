class CreatePowerChanges < ActiveRecord::Migration
  def self.up
    create_table :power_changes do |t|
      t.column :object_id, :integer, :null => false
      t.column :object_type, :string, :limit => 50, :null => false
      t.column :winning_party_id, :integer, :null => false
      t.column :losing_party_id, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :power_changes
  end
end
