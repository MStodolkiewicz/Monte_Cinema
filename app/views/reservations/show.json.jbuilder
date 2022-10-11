json.reservation do
  json.partial! "reservations/reservation", reservation: @reservation
end
