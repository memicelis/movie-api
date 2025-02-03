class AddIndexesToMovies < ActiveRecord::Migration[8.0]
  def change
    add_index :movies, :genre
    add_index :movies, :director
    add_index :movies, :release_date

    add_index :movies, [ :genre, :director ]
    add_index :movies, [ :genre, :release_date ]
    add_index :movies, [ :director, :release_date ]
  end
end
