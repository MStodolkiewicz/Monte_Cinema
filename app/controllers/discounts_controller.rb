class DiscountsController < ApplicationController
  include Pundit::Authorization

  before_action :set_discount, only: %i[edit update destroy]
  before_action :authenticate_user!

  # GET /discounts or /discounts.json
  def index
    authorize Discount
    @discounts = Discount.all
  end

  # GET /discounts/new
  def new
    authorize Discount
    @discount = Discount.new
  end

  # GET /discounts/1/edit
  def edit
    authorize Discount
  end

  # POST /discounts or /discounts.json
  def create
    authorize Discount
    @discount = Discount.new(discount_params)

    respond_to do |format|
      if @discount.save
        format.html { redirect_to discount_url(@discount), notice: "Discount was successfully created." }
        format.json { render :show, status: :created, location: @discount }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @discount.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discounts/1 or /discounts/1.json
  def update
    authorize @discount
    respond_to do |format|
      if @discount.update(discount_params)
        format.html { redirect_to discount_url(@discount), notice: "Discount was successfully updated." }
        format.json { render :show, status: :ok, location: @discount }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @discount.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discounts/1 or /discounts/1.json
  def destroy
    authorize @discount
    @discount.destroy

    respond_to do |format|
      format.html { redirect_to discounts_url, notice: "Discount was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_discount
    @discount = Discount.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def discount_params
    params.require(:discount).permit(:tickets_needed, :value)
  end
end
