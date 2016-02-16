class CreatePartyContributions < ActiveRecord::Migration
  def self.up
    create_table :party_contributions do |t|
			t.column :company_id, :integer, :null => false
			t.column :dem_amount, :double, :default => 0, :null => false
			t.column :rep_amount, :double, :default => 0, :null => false
			t.column :other_amount, :double, :default => 0, :null => false
    end
  end

  def self.down
    drop_table :party_contributions
  end
end
