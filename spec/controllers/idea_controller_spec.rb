require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe IdeasController, type: :controller do
  render_views


  let!(:user) { User.create!(first_name: 'Test first_name', last_name: 'Test last_name', email: 'test@test.com', password: 'asdfasdf') }

  let!(:valid_idea_attributes) { { title: 'Test idea title', summary: 'Test idea summary' } }

  let!(:idea1) { Idea.create!(title: 'Idea1 title', summary: 'Idea1 summary', user_id: user.id) }

  let!(:idea2) { Idea.create!(title: 'Idea2 title', summary: 'Idea2 summary', user_id: user.id) }

  describe 'GET #new' do
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

  describe 'GET #index' do

    it 'lists all the ideas' do
      get :index

      expect(response.body).to include("#{idea1.created_at.strftime('%y-%m-%d %H:%m')}")
      expect(response.body).to include("#{idea2.created_at.strftime('%y-%m-%d %H:%m')}")
      expect(response.body).to include("#{idea1.title}".html_safe)
      expect(response.body).to include("#{idea2.title}".html_safe)
    end
  end

  describe 'POST #create' do
    it 'creates a new idea and assigns it to @idea' do
      sign_in(user)

      expect{ post :create, params: { idea: valid_idea_attributes } }.to change{ Idea.count }.by(1)
    end
  end

  DatabaseCleaner.clean
end
