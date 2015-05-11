class Like < ActiveRecord::Base
	belongs_to :user
	belongs_to :movie

	validates :movie_id, uniqueness: { scope: :user_id }
	validates :user_id, uniqueness: { scope: :movie_id }

end
