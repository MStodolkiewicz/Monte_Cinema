class HallsController < ApplicationController
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  #Probably should move this after implementing errorhandler

  before_action :set_hall, only: %i[edit update destroy]
  before_action :manager_authenticate

  # GET /halls or /halls.json
  def index
    @halls = Hall.all
  end

  # GET /halls/new
  def new
    @hall = Hall.new
  end

  # GET /halls/1/edit
  def edit; end

  # POST /halls or /halls.json
  def create
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

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def manager_authenticate
    raise Pundit::NotAuthorizedError, "must be logged in" unless current_user
    authorize current_user, :manager?
  end
end
