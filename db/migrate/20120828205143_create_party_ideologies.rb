class CreatePartyIdeologies < ActiveRecord::Migration
  def self.up
    create_table :party_ideologies do |t|
      t.column :party_id, :integer, :null => false
      t.column :ideology_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :party_ideologies
  end
end
