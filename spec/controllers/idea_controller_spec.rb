require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe IdeasController, type: :controller do
  render_views

  let(:user) { User.create!(first_name: 'Test first_name', last_name: 'Test last_name', email: 'test@test.com', password: 'asdfasdf') }

  describe 'POST #new' do
    it 'creates a new idea and assigns it to @idea' do
      sign_in(user)

      get :new, params: { user_id: user.to_param }

      expect(assigns(:idea)).to be_a_new(Idea)
    end

    it 'renders a page for the user to create a new idea' do
      sign_in(user)

      get :new, params: { user_id: user.to_param }

      expect(response.body).to include('Post an Idea')
      expect(response.body).to include('form')
    end
  end

  DatabaseCleaner.clean
end
