5.times do
  User.create!(email: Faker::Internet.email, password: 123456, )
end 

User.all.each do |user|
  user.ideas.create!(title: Faker::Hipster.sentence, summary: Faker::Hipster.paragraphs[0])
end

# Idea.all.each do |idea|
#     idea.suggestions.create!(body: Faker::Hipster.sentence)
# end

# Suggestion.all.each do |suggestion|
#   rand(2..5).times do
#     suggestion.comments.create!(body: Faker::Hipster.sentence)
#   end
# end