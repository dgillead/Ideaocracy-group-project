5.times do
  User.create!(email: Faker::Internet.email, password: '123456', username: Faker::Name.last_name, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
end

  User.create!(email:'sw02102@gmail.com', password: '123456', username: 'dfsfs', first_name: 'jin', last_name: 'sdfsdf')

users = User.all

users.each do |user|
  rand(1..3).times do
    user.ideas.create!(title: Faker::Hipster.sentence, summary: "#{Faker::Hipster.paragraphs[0]}#{Faker::Hipster.paragraphs[0]}", collaborators: [1,2,3,4,5], loves: [1,2,3,4,5])

  end
end

Idea.all.each do |idea|
  rand(3..7).times do
    idea.suggestions.create!(body: Faker::Hipster.sentence, user_id: users[rand(0..4)].id)
  end
end

Suggestion.all.each do |suggestion|
  rand(4..7).times do
    suggestion.comments.create!(body: Faker::Hipster.sentence, user_id: users[rand(0..4)].id)
  end
end
