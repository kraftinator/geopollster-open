class CreateVoteCounts < ActiveRecord::Migration
  def self.up
    create_table :vote_counts do |t|
      t.column :object_id, :integer, :null => false
      t.column :object_type, :string, :limit => 50, :null => false
      t.column :party_id, :integer, :null => false
      t.column :total, :integer, :null => false
    end
  end

  def self.down
    drop_table :vote_counts
  end
end
