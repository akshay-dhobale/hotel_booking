class AddNumOfUserToBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :num_of_user, :integer
  end
end
