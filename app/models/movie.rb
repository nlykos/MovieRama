class Movie < ActiveRecord::Base
	belongs_to :user
	has_many :votes
	has_many :likes
	has_many :hates
	validates :title, presence: true, length: { maximum: 150 }
	validates :description, presence: true, length: { maximum: 65500 }
	validates :user_id, presence: true

	def likes_count
    likes.count
  end

  def hates_count
    hates.count
  end

end