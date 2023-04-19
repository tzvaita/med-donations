class AddUserToRequest < ActiveRecord::Migration[7.0]
  def change
    add_reference :requests, :user
  end
end
