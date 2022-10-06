class CancelReservationsJob < ApplicationJob
  queue_as :default

  def perform
    reservations.each do |reservation|
      cancel_reservation(reservation) if not_confirmed_on_time?(reservation)
    end
  end

  private

  def not_confirmed_on_time?(reservation)
    reservation.seance.start_time <= 30.minutes.from_now
  end

  def reservations
    Reservation.where(status: :reserved)
  end

  def cancel_reservation(reservation)
    reservation.update(status: :canceled)
  end
end