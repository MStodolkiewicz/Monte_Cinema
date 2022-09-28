class DiscountsController < ApplicationController
  include Pundit::Authorization

  before_action :set_discount, only: %i[edit update destroy]
  before_action :authenticate_user!

  def index
    authorize Discount
    @discounts = Discount.all
  end

  def new
    authorize Discount
    @discount = Discount.new
  end

  def edit
    authorize Discount
  end

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

  def destroy
    authorize @discount
    @discount.destroy

    respond_to do |format|
      format.html { redirect_to discounts_url, notice: "Discount was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_discount
    @discount = Discount.find(params[:id])
  end

  def discount_params
    params.require(:discount).permit(:tickets_needed, :value)
  end
end
