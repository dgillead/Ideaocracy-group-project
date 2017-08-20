5.times do
  User.create!(email: Faker::Internet.email, password: 123456, )
end 

User.all.each do |user|
  user.ideas.create!(title: Faker::Hipster.sentence, summary: Faker::Hipster.paragraphs)
end

Idea.all.each do |idea|
  rand(2..4).times do
    idea.comments.create!(body: Faker::Hipster.sentence)
  end
end