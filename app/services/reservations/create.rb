module Reservations
  class Create
    def initialize(**arguments)
      @user_id = arguments[:user_id]
      @email = arguments[:email]
      @seance_id = arguments[:seance_id]
      @seats = arguments[:seats]
      @status = arguments[:status]
      @errors = []
      @discount_id = largest_matching_discount(arguments[:seats].count)
      @reservation = Reservation.new(seance_id: @seance_id, user_id: @user_id, email: @email, status: @status,
                                     discount_id: @discount_id, seats: @seats)
      @seance = Seance.find(@seance_id)
    end

    attr_reader :errors

    def call
      return false unless seance_and_seats_valid?

      ActiveRecord::Base.transaction do
        @reservation.save!      
        create_tickets
      end

      ReservationMailer.reservation_created(@reservation.id).deliver_later unless @status == :confirmed
      true

      rescue StandardError => e
        @errors << "Booking reservation failed: #{e.message}"
        false
      end

    private

    def create_tickets
      @seats.each do |seat|
        Ticket.create!(reservation_id: @reservation.id, seat:)
      end
    end

    def largest_matching_discount(tickets_needed)
      Discount.where(tickets_needed: ..tickets_needed)
              .order(tickets_needed: :desc).pluck(:id).first
    end

    def seance_and_seats_valid?
      seanse_started? && number_of_seats_correct? && seats_not_duplicated?
    end

    def seanse_started?
      return true if @status == "confirmed" || @seance.start_time > 30.minutes.from_now

      raise SeanceStartedError
    end

    def number_of_seats_correct?
      return true unless @seats.count > 10 || @seats.first.empty?

      raise WrongNumberOfTicketsError 
    end

    def seats_not_duplicated?
      return true unless @seats.detect { |distinct| @seats.count(distinct) > 1 }

      raise SeatsDuplicatedError
    end
  end
end
