class CancelReservationsJob < ApplicationJob
  queue_as :default

  def perform
    pending_reservations.each do |reservation|
      reservation.update(status: :canceled)
      ReservationMailer.reservation_canceled(reservation).deliver_later
    end
  end

  private

  def pending_reservations
    Reservation.joins(:seance).where(status: :reserved).where(seance: { start_time: ..30.minutes.from_now })
  end
end
