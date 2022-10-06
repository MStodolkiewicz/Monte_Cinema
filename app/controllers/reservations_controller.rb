class ReservationsController < ApplicationController
  include Pundit::Authorization
  rescue_from ChangeStatusError, with: :change_status_error
  rescue_from SeanceStartedError, with: :seance_started_error
  rescue_from SeatTakenError, with: :seat_taken
  rescue_from TooManyTicketsError, with: :too_many_tickets
  rescue_from SeatsDuplicatedError, with: :seats_duplicated
  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found

  before_action :set_reservation, only: %i[show edit update destroy cancel confirm]
  before_action :authenticate_user!, except: %i[new create]

  def find_by_user
    authorize Reservation
    reservations_for_user(find_user_by_email!(params[:email]))
    render template: "reservations/index"
  end

  def find_by_seance
    authorize Reservation
    @reservations = reservations_for_seance(params[:seance_id])
    render template: "reservations/index"
  end

  def cancel
    authorize @reservation
    raise ChangeStatusError unless @reservation.status == 'reserved'

    change_status(status: :canceled)
  end

  def confirm
    authorize @reservation
    raise ChangeStatusError unless @reservation.status == 'reserved'

    change_status(status: :confirmed)
  end

  def index
    authorize Reservation
    reservations_for_user(current_user.id)
  end

  def show
    authorize @reservation
  end

  def new
    authorize Reservation
    @reservation = Reservation.new(seance_id: params[:seance_id])
    @reservation.email = current_user.email if current_user.present?
    params_for_form(params[:seance_id])
  end

  def edit
    authorize @reservation
    params_for_form(@reservation.seance_id)
  end

  def create
    authorize Reservation
    @reservation = Reservation.new(reservation_params)
    update_reservation_user if current_user.present?
    seance_and_seats_valid?

    Reservation.transaction do
      @reservation.save!
      create_tickets
    rescue StandardError
      redirect_to root_path, alert: 'Reservation was not created' and return
    end
    redirect_to root_path, notice: 'Reservation was successfully created.'
  end

  def update
    authorize @reservation
    seance_and_seats_valid?
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to reservation_url(@reservation), notice: "Reservation was successfully updated." }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @reservation
    @reservation.destroy

    respond_to do |format|
      format.html { redirect_to reservations_url, notice: "Reservation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def taken_seats(seance_id)
    @taken_seats = []
    Reservation.where(seance_id:).where.not(status: :canceled)
               .where.not(id: @reservation.id)
               .order(seats: :asc).pluck(:seats).each do |seat|
      @taken_seats |= seat
    end
    @taken_seats.sort!
  end

  def seats_already_reserved?
    taken_seats(@reservation.seance_id)
    @reservation.seats.each do |seat|
      raise SeatTakenError if @taken_seats.include?(seat)
    end
  end

  def number_of_seats_correct?
    raise TooManyTicketsError if @reservation.seats.count > 10
  end

  def seats_not_duplicated?
    raise SeatsDuplicatedError if @reservation.seats.detect { |distinct| @reservation.seats.count(distinct) > 1 }
  end

  def params_for_form(seance_id)
    taken_seats(seance_id)
    @capacity = Seance.where(id: seance_id)
                      .includes(:hall).pluck(:capacity)
  end

  def seance_and_seats_valid?
    seanse_started?
    seats_already_reserved?
    number_of_seats_correct?
    seats_not_duplicated?
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:seance_id, :email, seats: [])
  end

  def find_user_by_email!(email)
    User.find_by!(email:)
  end

  def find_user_by_email(email)
    User.find_by(email:)
  end

  def reservations_for_user(user_id)
    @reservations = Reservation.where(user_id:)
                               .joins(:seance).includes({ seance: [:movie] })
                               .order(start_time: :desc)
  end

  def reservations_for_seance(seance_id)
    Reservation.where(seance_id:)
               .includes({ seance: [:movie] })
  end

  def change_status(status)
    respond_to do |format|
      if @reservation.update(status)
        format.html { redirect_to reservation_url(@reservation), notice: "Status was successfully changed." }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  def seanse_started?
    @seance = Seance.find(@reservation.seance_id)
    if current_user.present? && policy(Reservation).create_when_started?
      raise SeanceStartedError if @seance.start_time <= -15.minutes.from_now
    elsif @seance.start_time <= 30.minutes.from_now
      raise SeanceStartedError
    end
  end

  def update_reservation_user
    if policy(Reservation).create_for_other_user?
      user = find_user_by_email(@reservation.email)
      @reservation.user_id = user.id if user.present?
      @reservation.status = "confirmed"
    else
      @reservation.user_id = current_user.id
    end
  end

  def create_tickets
    @reservation.seats.each do |seat|
      Ticket.create!(reservation_id: @reservation.id, seat:)
    end
  end

  def change_status_error
    flash[:alert] = "Cannot update status."
    redirect_back(fallback_location: reservations_path)
  end

  def seance_started_error
    flash[:alert] = "Reservations for this seance already closed"
    redirect_back(fallback_location: root_path)
  end

  def user_not_found
    flash[:alert] = "No user with given email"
    redirect_back(fallback_location: root_path)
  end

  def seat_taken
    flash[:alert] = "At least one of the seats is already reserved"
    redirect_back(fallback_location: root_path)
  end

  def too_many_tickets
    flash[:alert] = "Max 10 tickets per reservation allowed"
    redirect_back(fallback_location: root_path)
  end

  def seats_duplicated
    flash[:alert] = "At least one of the seats was duplicated"
    redirect_back(fallback_location: root_path)
  end
end
