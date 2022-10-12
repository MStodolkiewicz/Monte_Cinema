class ReservationMailer < ApplicationMailer
  helper :application
  def reservation_created(reservation_id)
    @reservation = Reservation.find(reservation_id)

    mail to: @reservation.email, subject: 'Reservation was successfully created!'
  end

  def reservation_canceled(reservation)
    @reservation = reservation

    mail to: @reservation.email, subject: 'Reservation was canceled.'
  end
end
