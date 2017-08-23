5.times do
  User.create!(email: Faker::Internet.email, password: 123456, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
end 

users = User.all

users.each do |user|
  rand(1..3).times do
    user.ideas.create!(title: Faker::Hipster.sentence, summary: "#{Faker::Hipster.paragraphs[0]}#{Faker::Hipster.paragraphs[0]}")
  end
end

Idea.all.each do |idea|
  rand(1..3).times do
    idea.suggestions.create!(body: Faker::Hipster.sentence, user_id: users[rand(0..4)].id)
  end
end

Suggestion.all.each do |suggestion|
  rand(2..5).times do
    suggestion.comments.create!(body: Faker::Hipster.sentence, user_id: users[rand(0..4)].id)
  end
end