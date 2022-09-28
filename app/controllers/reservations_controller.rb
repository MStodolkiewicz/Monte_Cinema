class ReservationsController < ApplicationController
  include Pundit::Authorization

  before_action :set_reservation, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def find_reservations_by_user
    @reservations = Reservation.where(user_id: 
      User.find_by(email: params[:email]))
    .joins(:seance).includes([:user, seance:[:movie]])
    .order(start_time: :desc)
    render template: "reservations/index"
  end

  def find_reservations_by_seance
    @reservations = Reservation.where(seance_id: params[:seance_id]).includes([:user, seance:[:movie]])
    render template: "reservations/index"
  end

  def index
    @reservations = Reservation.where(user_id: current_user.id).includes([:user, seance:[:movie]])
    render template: "reservations/index"
  end

  def show; end

  def new
    @reservation = Reservation.new(user_id: current_user.id, seance_id: params[:seance_id])
  end

  def edit; end

  def create
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

  def update
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
end
