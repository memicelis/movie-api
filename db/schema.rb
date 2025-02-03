# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_01_31_135335) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "follows", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "movie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_follows_on_movie_id"
    t.index ["user_id"], name: "index_follows_on_user_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.text "description"
    t.string "director"
    t.date "release_date"
    t.string "genre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["director", "release_date"], name: "index_movies_on_director_and_release_date"
    t.index ["director"], name: "index_movies_on_director"
    t.index ["genre", "director"], name: "index_movies_on_genre_and_director"
    t.index ["genre", "release_date"], name: "index_movies_on_genre_and_release_date"
    t.index ["genre"], name: "index_movies_on_genre"
    t.index ["release_date"], name: "index_movies_on_release_date"
    t.index ["slug"], name: "index_movies_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "follows", "movies"
  add_foreign_key "follows", "users"
end
