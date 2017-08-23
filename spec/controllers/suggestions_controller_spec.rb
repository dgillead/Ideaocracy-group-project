require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe SuggestionsController, type: :controller do
  render_views

  let!(:user) { User.create!(first_name: 'Test first_name', last_name: 'Test last_name', email: 'test@test.com', password: 'asdfasdf') }

  let!(:user2) { User.create!(first_name: 'Test first_name2', last_name: 'Test last_name2', email: 'test2@test.com', password: 'asdfasdf') }

  let!(:idea) { Idea.create!(title: 'Idea1 title', summary: 'Idea1 summary', user_id: user.id) }

  let!(:suggestion) { Suggestion.create!(idea_id: idea.id, body: 'suggestion body', user_id: user.id)}

  let!(:suggestion2) { Suggestion.create!(idea_id: idea.id, body: 'suggestion body', user_id: user2.id)}

  let(:valid_suggestion_attributes) { { body: 'Suggestion test body' } }

  describe 'POST #create' do
    it 'creates the new suggestion and assigns it to @suggestion' do
      sign_in(user)

      expect{ post :create, params: { idea_id: idea.id, user_id: user.id, body: 'Suggestion test body' } }.to change{ idea.suggestions.count }.by(1)
    end

    it 'redirects the user if they are not signed in' do
      post :create, params: { idea_id: idea.id, user_id: user.id, body: 'Suggestion test body' }

      expect(response.code).to eq('302')
    end
  end

  describe 'PATCH #up_vote' do
    it 'adds a vote count to suggestion' do
      sign_in(user)

      patch :up_vote, params: { suggestion_id: suggestion.id }
      suggestion.reload

      expect(suggestion.votes).to eq(2)
    end

    it 'will only add once' do
      sign_in(user)

      patch :up_vote, params: { suggestion_id: suggestion.id }
      patch :up_vote, params: { suggestion_id: suggestion.id }
      suggestion.reload

      expect(suggestion.votes).to eq(2)
    end

    it 'redirects the user if they are not signed in' do
      patch :up_vote, params: { suggestion_id: suggestion.id }

      expect(response.code).to eq('302')
    end
  end

  describe 'PATCH #down_vote' do
    it 'subtracts a vote count from suggestion' do
      sign_in(user)

      patch :down_vote, params: { suggestion_id: suggestion.id }
      suggestion.reload

      expect(suggestion.votes).to eq(0)
    end

    it 'will only subtract once' do
      sign_in(user)

      patch :down_vote, params: { suggestion_id: suggestion.id }
      patch :down_vote, params: { suggestion_id: suggestion.id }
      suggestion.reload

      expect(suggestion.votes).to eq(0)
    end

    it 'redirects the user if they are not signed in' do
      patch :down_vote, params: { suggestion_id: suggestion.id }

      expect(response.code).to eq('302')
    end
  end

  describe 'PUT #update' do
    it 'updates the suggestion' do
      sign_in(user)
      update_params = { body: 'new body' }

      put :update, params: { id: suggestion.id, suggestion: update_params }
      suggestion.reload

      expect(suggestion.body).to eq('new body')
    end

    it 'renders 404 when the user is not current user' do
      sign_in(user2)
      update_params = { body: 'new body' }

      put :update, params: { id: suggestion.id, suggestion: update_params }

      expect(response.body).to include("The page you were looking for doesn't exist.")
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the suggestion' do
      sign_in(user)

      expect{ delete :destroy, params: { id: suggestion.id } }.to change{ idea.suggestions.count }.by(-1)
    end

    it 'renders 404 when the user is not current user' do
      sign_in(user2)

      delete :destroy, params: { id: suggestion.id }

      expect(response.body).to include("The page you were looking for doesn't exist.")
    end
  end

  DatabaseCleaner.clean
end
