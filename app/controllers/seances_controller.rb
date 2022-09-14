class SeancesController < ApplicationController
  before_action :set_seance, only: %i[ show edit update destroy ]

  # GET /seances or /seances.json
  def index
    @seances = Seance.all
  end

  # GET /seances/1 or /seances/1.json
  def show
  end

  # GET /seances/new
  def new
    @seance = Seance.new
  end

  # GET /seances/1/edit
  def edit
  end

  # POST /seances or /seances.json
  def create
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