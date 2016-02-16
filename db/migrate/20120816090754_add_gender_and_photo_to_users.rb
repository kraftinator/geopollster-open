class AddGenderAndPhotoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :gender_id, :integer, :null => false
    add_column :users, :photo_url, :string, :null => true
  end

  def self.down
    remove_column :users, :photo_url
    remove_column :users, :gender_id
  end
end
