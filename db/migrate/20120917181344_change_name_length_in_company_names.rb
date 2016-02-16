class ChangeNameLengthInCompanyNames < ActiveRecord::Migration
  def self.up
    change_column :company_names, :name, :string, :limit => 100, :null => false
  end

  def self.down
    change_column :company_names, :name, :string, :limit => 50, :null => false
  end
end
