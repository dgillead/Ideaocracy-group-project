require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe IdeasController, type: :controller do
  render_views


  let!(:user) { User.create!(first_name: 'Test first_name', last_name: 'Test last_name', email: 'test@test.com', password: 'asdfasdf') }

  let!(:user2) { User.create!(first_name: 'Test first_name2', last_name: 'Test last_name2', email: 'test2@test.com', password: 'asdfasdf') }

  let!(:valid_idea_attributes) { { title: 'Test idea title', summary: 'Test idea summary' } }

  let!(:idea1) { Idea.create!(title: 'Idea1 title', summary: 'Idea1 summary', user_id: user.id) }

  let!(:idea2) { Idea.create!(title: 'Idea2 title', summary: 'Idea2 summary', user_id: user2.id) }

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

      expect(response.body).to include("#{idea1.title}".html_safe)
      expect(response.body).to include("#{idea2.title}".html_safe)
    end
  end

  describe 'POST #create' do
    it 'creates a new idea and assigns it to @idea' do
      sign_in(user)

      expect{ post :create, params: { idea: valid_idea_attributes } }.to change{ Idea.count }.by(1)
    end

    it 'redirects the user if they are not signed in' do
      post :create, params: { idea: valid_idea_attributes }

      expect(response.code).to eq('302')
    end
  end

  describe 'PUT #update' do
    it 'updates the idea with the new parameters' do
      sign_in(user)
      update_idea_attributes = {title: 'Idea update', summary: 'Summary update'}

      put :update, params: { idea: update_idea_attributes, id: idea1.id }
      idea1.reload

      expect(idea1.title).to eq('Idea update')
      expect(idea1.summary).to eq('Summary update')
    end

    it 'renders 404 when the user is not current user' do
      sign_in(user2)

      put :update, params: { id: idea1.id }

      expect(response.body).to include("The page you were looking for doesn't exist.")
    end
  end

  describe 'GET #show' do
    it 'shows the selected idea' do
      get :show, params: { id: idea1.id}

      expect(response.body).to include("#{idea1.title}")
      expect(response.body).to include("#{idea1.summary}")
    end

    it 'shows the add suggestion box for selected idea' do
      get :show, params: { id: idea1.id}

      expect(response.body).to include("Have a good suggestion?")
      expect(response.body).to include("Post your suggestion")
    end

    it 'shows the edit idea link if login user is the creator' do
      sign_in(user)

      get :show, params: { id: idea1.id}

      expect(response.body).to include("ideas/#{idea1.id}/edit")
    end

    it 'does not show edit idea link if login user is not the creator' do
      sign_in(user2)

      get :show, params: { id: idea1.id}

      expect(response.body).not_to include("ideas/#{idea1.id}/edit")
    end

    it 'shows the delete idea link if login user is the creator' do
      sign_in(user)

      get :show, params: { id: idea1.id}

      expect(response.body).to include("ideas/#{idea1.id}")
      expect(response.body).to include('data-method="delete"')
    end
  end

  describe 'GET #edit' do
    it 'renders a form for the user to edit the idea' do
      sign_in(user)

      get :edit, params: { id: idea1.id }

      expect(response.body).to include('Idea1 title')
      expect(response.body).to include('Idea1 summary')
      expect(response.body).to include('Edit Idea')
    end

    it 'renders 404 when the user is not current user' do
      sign_in(user2)

      get :edit, params: { id: idea1.id }

      expect(response.body).to include("The page you were looking for doesn't exist.")
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the selected idea' do
      sign_in(user)

      expect{ delete :destroy, params: { id: idea1.id } }.to change{ Idea.count }.by(-1)
    end

    it 'renders 404 when the user is not current user' do
      sign_in(user2)

      delete :destroy, params: { id: idea1.id }

      expect(response.body).to include("The page you were looking for doesn't exist.")
    end
  end

  DatabaseCleaner.clean
end
