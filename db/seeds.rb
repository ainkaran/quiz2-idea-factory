# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

PASSWORD = 'supersecret'

Review.destroy_all
Idea.destroy_all

User.destroy_all

User.create first_name: 'Ainkaran', last_name: 'Pathmanathan', email: 'pat.ainkaran@gmail.com', password: PASSWORD

10.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  User.create(
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name.downcase}-#{last_name.downcase}@example.com",
    password: PASSWORD
  )
end

users = User.all

100.times do
  idea = Idea.create(
    title: Faker::ChuckNorris.fact,
    description: Faker::Hacker.say_something_smart,
    user: users.sample
  )

  idea.likers = users.shuffle.slice(0..rand(users.count))
end

ideas = Idea.all

ideas.each do |idea|
  rand(1..5).times do
    Review.create(
      body: Faker::RickAndMorty.quote,
      idea: idea,
      user: users.sample
    )
  end
end

reviews = Review.all

puts Cowsay.say("Created #{users.count} users", :tux)
puts Cowsay.say('created 100 ideas', :cow)
puts Cowsay.say("Created #{Like.count} likes", :cheese)
puts Cowsay.say("created #{reviews.count} reviews", :ghostbusters)
