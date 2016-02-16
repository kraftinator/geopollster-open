class CreateIdeologies < ActiveRecord::Migration
  def self.up
    create_table :ideologies do |t|
      t.column :name, :string, :limit => 50, :null => false
      t.column :url, :string, :limit => 100, :default => '', :null => false
    end
  end

  def self.down
    drop_table :ideologies
  end
end
