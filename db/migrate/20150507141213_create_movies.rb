class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.integer :likes_sum, default: 0
      t.integer :hates_sum, default: 0
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
