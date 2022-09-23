class HallsController < ApplicationController
  include Pundit::Authorization

  before_action :set_hall, only: %i[edit update destroy]
  before_action :authenticate_user!

  # GET /halls or /halls.json
  def index
    authorize Hall
    @halls = Hall.all
  end

  # GET /halls/new
  def new
    authorize Hall
    @hall = Hall.new
  end

  # GET /halls/1/edit
  def edit
    authorize Hall
  end

  # POST /halls or /halls.json
  def create
    authorize Hall
    @hall = Hall.new(hall_params)

    respond_to do |format|
      if @hall.save
        format.html { redirect_to halls_url, notice: "Hall was successfully created." }
        format.json { render :show, status: :created, location: @hall }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @hall.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /halls/1 or /halls/1.json
  def update
    authorize @hall
    respond_to do |format|
      if @hall.update(hall_params)
        format.html { redirect_to halls_url, notice: "Hall was successfully updated." }
        format.json { render :show, status: :ok, location: @hall }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @hall.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /halls/1 or /halls/1.json
  def destroy
    authorize @hall
    @hall.destroy

    respond_to do |format|
      format.html { redirect_to halls_url, notice: "Hall was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_hall
    @hall = Hall.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def hall_params
    params.require(:hall).permit(:capacity, :name)
  end
end
