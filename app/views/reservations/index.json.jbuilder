json.reservations do
  json.array! @reservations, partial: "reservations/reservation", as: :reservation
end
