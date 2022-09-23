class SeancesController < ApplicationController
  include Pundit::Authorization

  before_action :set_seance, only: %i[edit update destroy]
  before_action :authenticate_user!

  # GET /seances/new
  def new
    authorize Seance
    @seance = Seance.new
  end

  # GET /seances/1/edit
  def edit
    authorize Seance
  end

  # POST /seances or /seances.json
  def create
    authorize Seance
    @seance = Seance.new(seance_params)

    respond_to do |format|
      if @seance.save
        format.html { redirect_to seance_url(@seance), notice: "Seance was successfully created." }
        format.json { render :show, status: :created, location: @seance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @seance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seances/1 or /seances/1.json
  def update
    authorize @seance
    respond_to do |format|
      if @seance.update(seance_params)
        format.html { redirect_to seance_url(@seance), notice: "Seance was successfully updated." }
        format.json { render :show, status: :ok, location: @seance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @seance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seances/1 or /seances/1.json
  def destroy
    authorize @seance
    @seance.destroy

    respond_to do |format|
      format.html { redirect_to seances_url, notice: "Seance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_seance
    @seance = Seance.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def seance_params
    params.require(:seance).permit(:start_time, :price, :hall_id, :movie_id)
  end
end
