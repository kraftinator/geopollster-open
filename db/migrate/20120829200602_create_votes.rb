class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.column :checkin_id, :integer, :null => false
      t.column :party_id, :integer, :null => false
      t.column :gender_id, :integer, :null => false
      t.column :mobile_device_id, :integer, :null => true
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :votes
  end
end
