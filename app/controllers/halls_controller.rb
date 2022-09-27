class HallsController < ApplicationController
  include Pundit::Authorization

  before_action :set_hall, only: %i[edit update destroy]
  before_action :authenticate_user!

  def index
    authorize Hall
    @halls = Hall.all
  end

  def new
    authorize Hall
    @hall = Hall.new
  end

  def edit
    authorize Hall
  end

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

  def destroy
    authorize @hall
    @hall.destroy

    respond_to do |format|
      format.html { redirect_to halls_url, notice: "Hall was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_hall
    @hall = Hall.find(params[:id])
  end

  def hall_params
    params.require(:hall).permit(:capacity, :name)
  end
end
