class AddSeatsToReservation < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :seats, :integer, array: true
  end
end
