class HatesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :can_vote, only: :create
  
  def create
    @hate = Hate.new(hate_params)
    if params[:status] == 'voted'
      @like = Like.where(user_id: params[:hate][:user_id], movie_id: params[:hate][:movie_id]).first
      @like.destroy
      @movie.likes_sum -= 1 #No save yet
    end
    if @hate.save
      @movie.hates_sum += 1
      @movie.save
      redirect_back_or root_url
    end
  end

  def destroy
    @hate=Hate.where(user_id: params[:id], movie_id: params[:movie_id]).first
    @movie = Movie.find(params[:movie_id])
    if @hate.destroy
      @movie.hates_sum -= 1
      @movie.save
      redirect_back_or root_url
    end
  end

  private

    # Check if can vote
    def can_vote
      if owner_user?
        redirect_back_or root_url 
        flash[:info] = "You are the owner."
      end
    end

    # Confirms movie owner.
    def owner_user?
      @movie = Movie.find(params[:hate][:movie_id])
      true if params[:hate][:user_id].to_i == @movie.user.id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hate_params
      params.require(:hate).permit(:user_id, :movie_id)
    end
end