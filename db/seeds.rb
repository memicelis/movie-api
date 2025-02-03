# db/seeds.rb
puts "Seeding database..."

# Create users if they don't exist
users = [
 { email: "admin@example.com", username: "admin", password: "password", role: :admin },
 { email: "moderator@example.com", username: "moderator", password: "password", role: :moderator },
 { email: "user1@example.com", username: "user1", password: "password", role: :user },
 { email: "user2@example.com", username: "user2", password: "password", role: :user },
 { email: "user3@example.com", username: "user3", password: "password", role: :user }
].map do |user_attrs|
 User.find_or_create_by!(email: user_attrs[:email]) do |user|
   user.username = user_attrs[:username]
   user.password = user_attrs[:password]
   user.role = user_attrs[:role]
 end
end

# Create movies if they don't exist
movies_data = [
 {
   title: "The Shawshank Redemption",
   description: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
   genre: "Drama",
   director: "Frank Darabont",
   release_date: "1994-09-23"
 },
 {
   title: "The Godfather",
   description: "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.",
   genre: "Crime",
   director: "Francis Ford Coppola",
   release_date: "1972-03-24"
 },
 {
   title: "Pulp Fiction",
   description: "The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.",
   genre: "Crime",
   director: "Quentin Tarantino",
   release_date: "1994-10-14"
 },
 {
   title: "The Dark Knight",
   description: "Batman confronts the Joker, a criminal mastermind unleashing chaos on Gotham City.",
   genre: "Action",
   director: "Christopher Nolan",
   release_date: "2008-07-18"
 },
 {
   title: "Inception",
   description: "A thief who steals corporate secrets through dream-sharing technology is given the task of planting an idea into a CEO's mind.",
   genre: "Sci-Fi",
   director: "Christopher Nolan",
   release_date: "2010-07-16"
 },
 {
   title: "The Matrix",
   description: "A computer programmer discovers that reality as he knows it is a simulation created by machines, and joins a rebellion to overthrow them.",
   genre: "Sci-Fi",
   director: "Wachowski Sisters",
   release_date: "1999-03-31"
 },
 {
   title: "Jurassic Park",
   description: "A pragmatic paleontologist touring an almost complete theme park on an island in Central America is tasked with protecting a couple of kids after a power failure causes the park's cloned dinosaurs to run loose.",
   genre: "Adventure",
   director: "Steven Spielberg",
   release_date: "1993-06-11"
 },
 {
   title: "Forrest Gump",
   description: "The presidencies of Kennedy and Johnson, the Vietnam War, the Watergate scandal and other historical events unfold from the perspective of an Alabama man with an IQ of 75.",
   genre: "Drama",
   director: "Robert Zemeckis",
   release_date: "1994-07-06"
 },
 {
   title: "Schindler's List",
   description: "In German-occupied Poland during World War II, industrialist Oskar Schindler gradually becomes concerned for his Jewish workforce after witnessing their persecution by the Nazis.",
   genre: "History",
   director: "Steven Spielberg",
   release_date: "1993-12-15"
 },
 {
   title: "Fight Club",
   description: "An insomniac office worker and a devil-may-care soap maker form an underground fight club that evolves into much more.",
   genre: "Drama",
   director: "David Fincher",
   release_date: "1999-10-15"
 },
 {
   title: "The Social Network",
   description: "As Harvard student Mark Zuckerberg creates the social networking site that would become known as Facebook, he is sued by the twins who claimed he stole their idea.",
   genre: "Biography",
   director: "David Fincher",
   release_date: "2010-10-01"
 },
 {
   title: "Interstellar",
   description: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.",
   genre: "Sci-Fi",
   director: "Christopher Nolan",
   release_date: "2014-11-07"
 },
 {
   title: "The Silence of the Lambs",
   description: "A young FBI cadet must receive the help of an incarcerated and manipulative cannibal killer to help catch another serial killer.",
   genre: "Thriller",
   director: "Jonathan Demme",
   release_date: "1991-02-14"
 },
 {
   title: "Goodfellas",
   description: "The story of Henry Hill and his life in the mob, covering his relationship with his wife Karen Hill and his mob partners Jimmy Conway and Tommy DeVito.",
   genre: "Crime",
   director: "Martin Scorsese",
   release_date: "1990-09-19"
 },
 {
   title: "The Departed",
   description: "An undercover cop and a mole in the police attempt to identify each other while infiltrating an Irish gang in South Boston.",
   genre: "Crime",
   director: "Martin Scorsese",
   release_date: "2006-10-06"
 },
 {
   title: "Gladiator",
   description: "A former Roman General sets out to exact vengeance against the corrupt emperor who murdered his family and sent him into slavery.",
   genre: "Action",
   director: "Ridley Scott",
   release_date: "2000-05-05"
 },
 {
   title: "The Grand Budapest Hotel",
   description: "A writer encounters the owner of an aging high-class hotel, who tells him of his early years serving as a lobby boy in the hotel's glorious years under an exceptional concierge.",
   genre: "Comedy",
   director: "Wes Anderson",
   release_date: "2014-03-28"
 },
 {
   title: "Saving Private Ryan",
   description: "Following the Normandy Landings, a group of U.S. soldiers go behind enemy lines to retrieve a paratrooper whose brothers have been killed in action.",
   genre: "War",
   director: "Steven Spielberg",
   release_date: "1998-07-24"
 },
 {
   title: "The Green Mile",
   description: "The lives of guards on Death Row are affected by one of their charges: a black man accused of child murder and rape, yet who has a mysterious gift.",
   genre: "Drama",
   director: "Frank Darabont",
   release_date: "1999-12-10"
 },
 {
   title: "Kill Bill: Vol. 1",
   description: "After awakening from a four-year coma, a former assassin wreaks vengeance on the team of assassins who betrayed her.",
   genre: "Action",
   director: "Quentin Tarantino",
   release_date: "2003-10-10"
 },
 {
   title: "Memento",
   description: "A man with short-term memory loss attempts to track down his wife's murderer.",
   genre: "Thriller",
   director: "Christopher Nolan",
   release_date: "2000-10-11"
 }
].map do |movie_attrs|
 Movie.find_or_create_by!(title: movie_attrs[:title]) do |movie|
   movie.description = movie_attrs[:description]
   movie.genre = movie_attrs[:genre]
   movie.director = movie_attrs[:director]
   movie.release_date = movie_attrs[:release_date]
 end
end

# Create 50 random follows
users.each do |user|
 # Get random number of movies to follow (between 8-12)
 movies_to_follow = movies_data.sample(rand(8..12))

 movies_to_follow.each do |movie_attrs|
   movie = Movie.find_by!(title: movie_attrs[:title])
   Follow.find_or_create_by!(user: user, movie: movie)
 end
end

puts "Seeding completed!"
puts "  Users: #{User.count}"
puts "  Movies: #{Movie.count}"
puts "  Follows: #{Follow.count}"
