class Ticket < ApplicationRecord
  belongs_to :reservation
  validates :seat, presence: true, numericality: { greater_than: 0 }
  validate :seat_over_capacity?
  validate :seat_free?

  private

  def seat_over_capacity?
    return if seat_in_capacity?

    errors.add(:seat, 'is over the hall capacity')
  end

  def seat_in_capacity?
    seat <= reservation.seance.hall.capacity
  end

  def seat_free?
    return unless seat_reserved?

    errors.add(:seat, "already reserved")
  end

  def seat_reserved?
    Ticket.joins(:reservation).where(reservation: { seance_id: reservation.seance_id }).pluck(:seat).include?(seat)
  end
end
