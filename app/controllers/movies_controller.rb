class MoviesController < ApplicationController
  include Pundit::Authorization

  before_action :set_movie, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]

  def index
    authorize Movie
    @movies = Movie.all
    @discounts = Discount.all
  end

  def show
    authorize @movie
    @seances = Seance
               .where(movie_id: params[:id])
               .where(start_time: 30.minutes.from_now..7.days.from_now)
               .order(start_time: :asc)
  end

  def new
    authorize Movie
    @movie = Movie.new
  end

  def edit
    authorize Movie
  end

  def create
    authorize Movie
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @movie
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to movie_url(@movie), notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @movie
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def movie_params
    params.require(:movie).permit(:name, :description, :duration)
  end
end
