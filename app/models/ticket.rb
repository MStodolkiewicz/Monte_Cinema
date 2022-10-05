class Ticket < ApplicationRecord
  belongs_to :reservation
  validates :seat, presence: true, numericality: { greater_than: 0 }
  validate :seat_over_capacity?

  private
  def seat_over_capacity?
    errors.add(seat: 'Seat is over the hall capacity') unless seat <= reservation.seance.hall.capacity
  end
end
