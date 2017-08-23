require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe CommentsController, type: :controller do
  render_views

  let!(:user) { User.create!(first_name: 'Test first_name', last_name: 'Test last_name', email: 'test@test.com', password: 'asdfasdf') }

  let!(:user2) { User.create!(first_name: 'Test first_name2', last_name: 'Test last_name2', email: 'test2@test.com', password: 'asdfasdf') }

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

  describe 'PUT #update' do
    let(:comment_params) { {body: 'new comment body'} }
    let(:comment) { suggestion.comments.create!(user_id: user.id, body: 'Comment test body') }
    it 'updates the comment' do
      sign_in(user)

      put :update, params: { id: comment.id, comment: comment_params }
      comment.reload

      expect(comment.body).to eq('new comment body')
    end

    it 'renders 404 when the user is not current user' do
      sign_in(user2)

      put :update, params: { id: comment.id, comment: comment_params }

      expect(response.body).to include("The page you were looking for doesn't exist.")
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { suggestion.comments.create!(user_id: user.id, body: 'Comment test body') }
    it 'deletes the comment' do
      sign_in(user)

      expect{ delete :destroy, params: { id: comment.id } }.to change{ suggestion.comments.count }.by(-1)
    end

    it 'renders 404 when the user is not current user' do
      sign_in(user2)

      delete :destroy, params: { id: comment.id }

      expect(response.body).to include("The page you were looking for doesn't exist.")
    end

    it 'renders 404 when the comment id does not exist' do
      sign_in(user)

      delete :destroy, params: { id: -1 }

      expect(response.body).to include("The page you were looking for doesn't exist.")
    end
  end
end
