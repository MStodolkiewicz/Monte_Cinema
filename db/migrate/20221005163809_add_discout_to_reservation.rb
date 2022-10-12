class AddDiscoutToReservation < ActiveRecord::Migration[7.0]
  def change
    add_reference :reservations, :discount, foreign_key: true
  end
end
