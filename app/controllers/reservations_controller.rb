class ReservationsController < ApplicationController
  include Pundit::Authorization

  before_action :set_reservation, only: %i[show edit update destroy cancel_reservation confirm_reservation]
  before_action :authenticate_user!

  def find_reservations_by_user
    authorize Reservation
    index(find_user_by_email(params[:email]))
  end

  def find_reservations_by_seance
    authorize Reservation
    @reservations = Reservation.where(seance_id: params[:seance_id])
                               .includes([:user, { seance: [:movie] }])
    render template: "reservations/index"
  end

  def cancel_reservation
    authorize @reservation
    update(status: :canceled)
  end

  def confirm_reservation
    authorize @reservation
    update(status: :confirmed)
  end

  def index(user_id = current_user.id)
    authorize Reservation
    @reservations = Reservation.where(user_id:)
                               .joins(:seance).includes([:user, { seance: [:movie] }])
                               .order(start_time: :desc)
    render template: "reservations/index"
  end

  def show
    authorize @reservation
  end

  def new
    authorize Reservation
    @reservation = Reservation.new(user_id: current_user.id, seance_id: params[:seance_id])
  end

  def edit
    authorize @reservation
  end

  def create
    authorize Reservation
    @reservation = Reservation.new(reservation_params)

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to reservation_url(@reservation), notice: "Reservation was successfully created." }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update(status = reservation_params)
    authorize @reservation
    respond_to do |format|
      if @reservation.update(status)
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

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:status, :seance_id, :user_id)
  end

  def find_user_by_email(email)
    User.find_by(email:)
  end
end
