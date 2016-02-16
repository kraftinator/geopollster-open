class CreateCompanyNames < ActiveRecord::Migration
  def self.up
    create_table :company_names do |t|
			t.column :company_id, :integer, :null => false
			t.column :name, :string, :limit => 50, :null => false
    end
  end

  def self.down
    drop_table :company_names
  end
end
