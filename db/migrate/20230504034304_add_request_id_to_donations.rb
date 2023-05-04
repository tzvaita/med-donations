class AddRequestIdToDonations < ActiveRecord::Migration[7.0]
  def change
    add_column :donations, :request_id, :integer
  end
end
