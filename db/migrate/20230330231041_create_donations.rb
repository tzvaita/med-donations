class CreateDonations < ActiveRecord::Migration[7.0]
  def change
    create_table :donations do |t|
      t.string :name
      t.integer :quantity

      t.timestamps
    end
  end
end
