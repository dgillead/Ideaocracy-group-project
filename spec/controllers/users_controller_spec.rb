require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe UsersController, type: :controller do
  render_views

  let!(:user) { User.create!(first_name: 'Test first_name', last_name: 'Test last_name', email: 'test@test.com', password: 'asdfasdf') }
  let!(:user2) { User.create!(first_name: 'Test first_name2', last_name: 'Test last_name2', email: 'test2@test.com', password: 'asdfasdf') }
  let!(:idea) { Idea.create!(title: 'Idea1 title', summary: 'Idea1 summary', user_id: user.id) }
  let!(:idea2) { Idea.create!(title: 'Idea2 title', summary: 'Idea2 summary', user_id: user2.id) }

  let!(:idea3) { Idea.create!(title: 'Idea3 title', summary: 'Idea3 summary', user_id: user2.id) }
  let!(:suggestion) { Suggestion.create!(idea_id: idea.id, body: 'suggestion body', user_id: user.id)}
  let!(:suggestion2) { Suggestion.create!(idea_id: idea.id, body: 'suggestion body', user_id: user2.id)}
  let!(:comment) { Comment.create!(suggestion_id: suggestion.id, user_id: user.id, body: 'Comment test body')}
  let!(:comment2) { Comment.create!(suggestion_id: suggestion.id, user_id: user2.id, body: 'Comment test body')}

  describe 'GET #suggestions' do
    it 'displays user suggestions' do
      sign_in(user)

      get :suggestions
      
      expect(response.body).to include('Suggestions')
    end

    it 'redirect to sign in when the user is not current user' do
      sign_in(user)      
      
      get :suggestions

      expect(response.body).not_to include{ user2.suggestion.first.body }
    end
  end

  describe 'GET #ideas' do
      it 'displays user suggestions' do
      
      sign_in(user)
     
      get :ideas

      expect(response.body).to include('Ideas')
            
      end

      it 'redirect to sign in when the user is not current user' do
        sign_in(user) 
      
        get :ideas

        expect(response.body).not_to include{ user2.idea.first.title }   
      end
  end

  describe 'GET #comments' do
    it 'displays user suggestions' do

      sign_in(user)
      
      get :comments
      
      expect(response.body).to include('Comments')
    end
  
    it 'redirect to sign in when the user is not current user' do
      sign_in(user2)
      
      get :comments
      
      expect(response.body).not_to include{ user2.comment.first.body }
    end
  end

  describe 'GET #loves' do
    let(:user3) { User.create!(first_name: 'Test3 first_name', last_name: 'Test3 last_name', email: 'test3@test.com', password: 'asdfasdf', loves: [idea.id, idea2.id]) }
    it 'displays user loved ideas' do
      sign_in(user3)

      get :loves

      expect(response.body).to include( idea.title )
      expect(response.body).to include( idea2.title )
    end

    it 'only displays user loved ideas' do
      sign_in(user3)

      get :loves

      expect(response.body).not_to include( idea3.title )
    end
  end
  DatabaseCleaner.clean
end
