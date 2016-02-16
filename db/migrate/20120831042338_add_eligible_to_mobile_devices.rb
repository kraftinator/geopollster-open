class AddEligibleToMobileDevices < ActiveRecord::Migration
  def self.up
    add_column :mobile_devices, :eligible, :boolean, :default => false
  end

  def self.down
    remove_column :mobile_devices, :eligible
  end
end
