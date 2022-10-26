class ReservationsController < ApplicationController
  include Pundit::Authorization
  rescue_from ChangeStatusError, with: :change_status_error
  rescue_from NoUserForEmailError, with: :user_not_found

  before_action :set_reservation, only: %i[show destroy cancel confirm]
  before_action :authenticate_user!, except: %i[new create_as_guest]

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

  def create
    authorize Reservation
    @reservation = Reservations::Create.new(**{ user_id: current_user.id, email: current_user.email,
                                                  seance_id: reservation_params[:seance_id], seats: reservation_params[:seats], status: :reserved })

    create_call(@reservation)
  end

  def create_as_manager
    authorize Reservation
    @reservation = Reservations::Create.new(**{ user_id: current_user.id, email: current_user.email,
                                                  seance_id: reservation_params[:seance_id], seats: reservation_params[:seats], status: :confirmed })

    create_call(@reservation)
  end

  def create_as_guest
    authorize Reservation
    @reservation = Reservations::Create.new(**{ email: reservation_params[:email], seance_id: reservation_params[:seance_id], seats: reservation_params[:seats], status: :reserved })

    create_call(@reservation)
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

  def params_for_form(seance_id)
    taken_seats(seance_id)
    @capacity = Seance.where(id: seance_id)
                      .includes(:hall).pluck(:capacity)
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:seance_id, :email, seats: [])
  end

  def find_user_by_email!(email)
    raise NoUserForEmailError unless User.find_by(email:)
  end

  def reservations_for_user(user_id)
    @reservations = Reservation.where(user_id:)
                               .joins(:seance).includes({ seance: [:movie] }, :discount)
                               .order(start_time: :desc)
  end

  def reservations_for_seance(seance_id)
    Reservation.where(seance_id:)
               .includes({ seance: [:movie] }, :discount)
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

  def create_call(reservation)
    if reservation.call
      redirect_to movies_path, notice: "Reservation successfully created"
    else
      redirect_to root_path, alert: reservation.errors
    end
  end

  def change_status_error
    flash[:alert] = "Cannot update status."
    redirect_back(fallback_location: reservations_path)
  end

  def user_not_found
    flash[:alert] = "No user with given email"
    redirect_back(fallback_location: root_path)
  end
end
