class SeancesController < ApplicationController
  include Pundit::Authorization

  before_action :set_seance, only: %i[edit update destroy]
  before_action :authenticate_user!

  def new
    authorize Seance
    @seance = Seance.new(movie_id: params[:movie_id])
  end

  def edit
    authorize Seance
  end

  def create
    authorize Seance
    @seance = Seance.new(seance_params)

    respond_to do |format|
      if @seance.save
        format.html { redirect_to movie_url(@seance.movie_id), notice: "Seance was successfully created." }
        format.json { render :show, status: :created, location: @seance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @seance.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @seance
    respond_to do |format|
      if @seance.update(seance_params)
        format.html { redirect_to movie_url(@seance.movie_id), notice: "Seance was successfully updated." }
        format.json { render :show, status: :ok, location: @seance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @seance.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @seance
    @seance.destroy

    respond_to do |format|
      format.html { redirect_to movie_url(@seance.movie_id), notice: "Seance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_seance
    @seance = Seance.find(params[:id])
  end

  def seance_params
    params.require(:seance).permit(:start_time, :price, :hall_id, :movie_id)
  end
end
