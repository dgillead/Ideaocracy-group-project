require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe SuggestionsController, type: :controller do
  render_views

  let!(:user) { User.create!(first_name: 'Test first_name', last_name: 'Test last_name', email: 'test@test.com', password: 'asdfasdf') }

  let!(:idea) { Idea.create!(title: 'Idea1 title', summary: 'Idea1 summary', user_id: user.id) }

  let(:valid_suggestion_attributes) { { body: 'Suggestion test body' } }

  describe 'POST #create' do
    it 'creates the new suggestion and assigns it to @suggestion' do
      sign_in(user)

      expect{ post :create, params: { idea_id: idea.id, user_id: user.id, body: 'Suggestion test body' } }.to change{ idea.suggestions.count }.by(1)
    end
  end

  DatabaseCleaner.clean
end
