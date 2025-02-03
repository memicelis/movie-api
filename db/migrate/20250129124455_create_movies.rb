class CreateMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.string :director
      t.date :release_date
      t.string :genre

      t.timestamps
    end
    add_index :movies, :slug, unique: true
  end
end
