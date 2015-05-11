class LikesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :can_vote, only: :create
  
  def create
    @like = Like.new(like_params)
    if params[:status] == 'voted'
      @hate = Hate.where(user_id: params[:like][:user_id], movie_id: params[:like][:movie_id]).first
      @hate.destroy
      @movie.hates_sum -= 1 #No save yet
    end
    if @like.save
      @movie.likes_sum += 1
      @movie.save
      redirect_back_or root_url
    end
  end

  def destroy
    @like=Like.where(user_id: params[:id], movie_id: params[:movie_id]).first
    @movie = Movie.find(params[:movie_id])
    if @like.destroy
      @movie.likes_sum -= 1
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
      @movie = Movie.includes(:user).find(params[:like][:movie_id])
      true if params[:like][:user_id].to_i == @movie.user.id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def like_params
      params.require(:like).permit(:user_id, :movie_id)
    end
end