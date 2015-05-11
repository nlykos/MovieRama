class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:destroy, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  # GET /movies
  def index
    @movies = Movie.all.includes(:user, :likes, :hates).order(sort_column+' desc')
  end

  # GET /movies/1
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  def create
    @movie = Movie.new(movie_params)

    @movie[:user_id] = current_user.id

    if @movie.save
      flash[:info] = 'Movie was successfully created.'
      redirect_to @movie
    else
      render :new
    end
  end

  # PATCH/PUT /movies/1
  def update
    if @movie.update(movie_params)
      flash[:info] = 'Movie was successfully updated.'
      redirect_to @movie
    else
      render :edit
    end
  end

  # DELETE /movies/1
  def destroy
    if @movie.destroy
      flash[:info] = 'Movie was successfully destroyed.'
      redirect_to movies_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:title, :description, :likes, :hates, :user_id)
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find_by_id(@movie.user_id)
      unless (current_user?(@user) || current_user.admin)
        redirect_to(root_url)
      end
    end

end