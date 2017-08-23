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

    it 'redirects the user if they are not signed in' do
      post :create, params: { idea_id: idea1.id, suggestion_id: suggestion.id, user_id: user.id, body: 'Comment test body' }

      expect(response.code).to eq('302')
    end
  end

  describe 'GET #edit' do
    let(:comment) { suggestion.comments.create!(user_id: user.id, body: 'Comment test body') }
    it 'renders a form for the user to edit the comment' do
      sign_in(user)

      get :edit, params: { id: comment.id }

      expect(response.body).to include("#{comment.body}")
      expect(response.body).to include("Edit Comment")
    end

    it 'will ask for sign in when user is not sign in' do
      get :edit, params: { id: comment.id }

      expect(response.code).to eq("302")
    end
  end

  describe 'PUT #update' do
    let(:comment_params) { {body: 'new comment body'} }
    let(:comment) { suggestion.comments.create!(user_id: user.id, body: 'Comment test body') }
    it 'updates the comment' do
      sign_in(user)

      patch :update, params: { comment: comment_params }
      comment.reload

      expect(comment.body).to eq('new comment body')
    end
  end
end
