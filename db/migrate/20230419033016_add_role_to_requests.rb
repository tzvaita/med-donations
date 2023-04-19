class AddRoleToRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :role, :integer, default: 0
  end
end
