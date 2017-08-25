require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe TrelloApiController, type: :controller do
  render_views

  let!(:user) { User.create!(first_name: 'Test first_name', last_name: 'Test last_name', username: 'username1', email: 'test@test.com', password: 'asdfasdf') }

  let!(:user2) { User.create!(first_name: 'Test first_name2', last_name: 'Test last_name2', username: 'username2', email: 'test2@test.com', password: 'asdfasdf', trello: "#{Rails.application.secrets.trello_user_token}") }

  let!(:idea) { Idea.create!(title: 'Idea1 title', summary: 'Idea1 summary', user_id: user2.id, collaborators: [user.id, user2.id]) }

  let!(:idea2) { Idea.create!(title: 'Idea2 title', summary: 'Idea2 summary', user_id: user.id, collaborators: [user.id, user2.id]) }

  let!(:suggestion) { Suggestion.create!(idea_id: idea.id, body: 'suggestion body', user_id: user.id)}

  let!(:suggestion2) { Suggestion.create!(idea_id: idea2.id, body: 'suggestion body', user_id: user2.id)}

  describe 'GET #new' do
    it 'displays a form for the user to create trello board if trello is authorized' do
      sign_in(user2)

      get :new, params: { idea_id: idea.id, collaborators: idea.collaborators }

      expect(response.body).to include('Idea1 title')
      expect(response.body).to include('suggestion body')
      expect(response.body).to include('username2')
      expect(response.body).to include('Create Trello Board')
    end

    it 'asks user to authorize trello if not authorized' do
      sign_in(user)

      get :new, params: { idea_id: idea2.id, collaborators: idea.collaborators }

      expect(response.body).to include('Idea2 title')
      expect(response.body).to include('suggestion body')
      expect(response.body).to include('username2')
      expect(response.body).to include('Authorize Trello')
    end
  end

  describe 'POST #create' do
    xit 'creates a trello board' do
      sign_in(user2)

      post :create_board, params: { board: 'Test board', suggestions: ['test suggestion 1', 'test suggestion 2'], collaborators: [user.id, user2.id]}

      expect(response.body).to include('Board created successfully.')
    end
  end

end
