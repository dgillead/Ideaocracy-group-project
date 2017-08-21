require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe CommentsController, type: :controller do
  render_views

  let!(:user) { User.create!(first_name: 'Test first_name', last_name: 'Test last_name', email: 'test@test.com', password: 'asdfasdf') }

  let!(:idea1) { Idea.create!(title: 'Idea1 title', summary: 'Idea1 summary', user_id: user.id) }

  let!(:suggestion) { Suggestion.create!(body: 'Suggestion test body', user_id: user.id, idea_id: idea1.id) }

  describe 'POST #create' do
    it 'creates a new comment and assigns it to @comment' do
      sign_in(user)

      expect{ post :create, params: { idea_id: idea1.id, suggestion_id: suggestion.id, user_id: user.id, body: 'Comment test body' } }.to change{ suggestion.comments.count }.by(1)
    end
  end


end