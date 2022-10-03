class ReservationsController < ApplicationController
  include Pundit::Authorization

  before_action :set_reservation, only: %i[show edit update destroy cancel confirm]
  before_action :authenticate_user!, except: %i[new create]

  def find_by_user
    authorize Reservation
    reservations_for_user(find_user_by_email(params[:email]))
    render template: "reservations/index"
  end

  def find_by_seance
    authorize Reservation
    @reservations = Reservation.where(seance_id: params[:seance_id])
                               .includes([:user, { seance: [:movie] }])
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
  end

  def edit
    authorize @reservation
  end

  def create
    authorize Reservation
    @reservation = Reservation.new(reservation_params)

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to root_path, notice: "Reservation was successfully created." }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @reservation
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

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:seance_id, :email)
  end

  def find_user_by_email(email)
    User.find_by(email:)
  end

  def reservations_for_user(user_id)
    @reservations = Reservation.where(user_id:)
                               .joins(:seance).includes([:user, { seance: [:movie] }])
                               .order(start_time: :desc)
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
end
