class AddTargetedToDonations < ActiveRecord::Migration[7.0]
  def change
    add_column :donations, :targeted, :boolean, default: false
  end
end
