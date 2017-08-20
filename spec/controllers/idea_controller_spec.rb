require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe IdeasController, type: :controller do
  render_views

  let(:user1) { User.create!(first_name: 'Test first_name', last_name: 'Test last_name', email: 'test1@test.com', password: 'asdfasdf') }

  let(:user2) { User.create!(first_name: 'Test first_name', last_name: 'Test last_name', email: 'test2@test.com', password: 'asdfasdf') }

  let!(:idea1) { Idea.create!(title: Faker::Hipster.sentence, summary: "#{Faker::Hipster.paragraphs[0]}", user_id: user1.id)}

  let!(:idea2) { Idea.create!(title: Faker::Hipster.sentence, summary: "#{Faker::Hipster.paragraphs[0]}", user_id: user2.id)}

  describe 'GET #new' do
    it 'creates a new idea and assigns it to @idea' do
      sign_in(user1)

      get :new, params: { user_id: user1.to_param }

      expect(assigns(:idea)).to be_a_new(Idea)
    end

    it 'renders a page for the user to create a new idea' do
      sign_in(user2)

      get :new, params: { user_id: user2.to_param }

      expect(response.body).to include('Post an Idea')
      expect(response.body).to include('form')
    end

    xit 'redirect to sign in page when not sign in' do
      get :new

      expect(response.body).to include('Sign in')
      expect(response.body).to include('form')
    end
  end

  describe 'GET #index' do

    it 'lists all the ideas' do
      get :index

      expect(response.body).to include("#{idea1.created_at.strftime('%y-%m-%d %H:%m')}")
      expect(response.body).to include("#{idea2.created_at.strftime('%y-%m-%d %H:%m')}")
      expect(response.body).to include("#{idea1.title}".html_safe)
      expect(response.body).to include("#{idea2.title}".html_safe)
    end
  end

  DatabaseCleaner.clean
end
