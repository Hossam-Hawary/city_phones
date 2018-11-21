class AddPickedBySysToPhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    add_column :phone_numbers, :picked_by_sys, :boolean
    add_index :phone_numbers, :picked_by_sys
  end
end
