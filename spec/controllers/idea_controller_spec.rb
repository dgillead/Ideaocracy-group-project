require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe IdeasController, type: :controller do
  render_views


  let!(:user) { User.create!(first_name: 'Test first_name', last_name: 'Test last_name', email: 'test@test.com', password: 'asdfasdf') }

  let!(:user2) { User.create!(first_name: 'Test first_name2', last_name: 'Test last_name2', email: 'test2@test.com', password: 'asdfasdf') }

  let!(:valid_idea_attributes) { { title: 'Test idea title', summary: 'Test idea summary' } }

  let!(:idea1) { Idea.create!(title: 'Idea1 title', summary: 'Idea1 summary', tags: 'idea1, hello, i am an idea, test me, both', user_id: user.id) }

  let!(:idea2) { Idea.create!(title: 'Idea2 title', summary: 'Idea2 summary', tags: 'idea2, goodbye, i am an another idea, test me too, both', user_id: user2.id) }

  describe 'GET #search' do
    it 'returns ideas whose tags match the search params (idea1)' do
      sign_in(user)

      get :search_tags, params: { q: 'idea1' }

      expect(response.body).to include('Idea1 title')
      expect(response.body).to_not include('Idea2 title')
    end

    it 'returns ideas whos tags match the search params (idea2)' do
      sign_in(user)

      get :search_tags, params: { q: 'goodbye' }

      expect(response.body).to include('Idea2 title')
      expect(response.body).to_not include('Idea1 title')
    end

    it 'returns ideas whose tags match the search params (both)' do
      sign_in(user)

      get :search_tags, params: { q: 'both' }

      expect(response.body).to include('Idea2 title')
      expect(response.body).to include('Idea1 title')
    end

    it 'lets the user know if the search returns no results' do
      sign_in(user)

      get :search_tags, params: { q: 'neither'}

      expect(response.body).to include('No ideas found')
    end
  end

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

    it 'renders 404 when the idea id does not exist' do
      sign_in(user)

      put :update, params: { id: -1 }

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

    it 'renders 404 when the idea id does not exist' do
      sign_in(user)

      get :show, params: { id: -1 }

      expect(response.body).to include("The page you were looking for doesn't exist.")
    end

    it 'shows a link to create a trello board if login as creator' do
      sign_in(user)

      get :show, params: { id: idea1.id}

      expect(response.body).to include('Create Trello Board')
    end

    it 'does not show a link to create a trello board if not login as creator' do
      sign_in(user2)

      get :show, params: { id: idea1.id}

      expect(response.body).not_to include('Create Trello Board')
    end

    it 'does not show a link to create a trello board if not login' do
      get :show, params: { id: idea1.id}

      expect(response.body).not_to include('Create Trello Board')
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

    it 'renders 404 when the idea id does not exist' do
      sign_in(user)

      get :edit, params: { id: -1 }

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

    it 'renders 404 when the idea id does not exist' do
      sign_in(user)

      delete :destroy, params: { id: -1 }

      expect(response.body).to include("The page you were looking for doesn't exist.")
    end
  end

  describe 'GET #new_collaborator' do
    it 'add the user to collaborator list when user sign in' do
      sign_in(user)

      get :new_collaborator, params: {id: idea1.id}
      idea1.reload

      expect(idea1.collaborators.count).to eq(1)
      expect(response.code).to eq('302')
    end

    it 'will not add the user to collaborator list when not sign in' do

      get :new_collaborator, params: {id: idea1.id}
      idea1.reload

      expect(idea1.collaborators.count).to eq(0)
    end

    it 'will not add the user to collaborator list when user already on the list' do
      sign_in(user)

      get :new_collaborator, params: {id: idea1.id}
      get :new_collaborator, params: {id: idea1.id}
      idea1.reload

      expect(idea1.collaborators.count).to eq(1)
    end
  end

  describe 'GET #delete_collaborator' do
    let(:idea3) { Idea.create!(title: 'Idea3 title', summary: 'Idea3 summary', user_id: user.id, collaborators: [user.id]) }
    it 'will not remove the user to collaborator list when not sign in' do

      get :delete_collaborator, params: {id: idea3.id}
      idea3.reload

      expect(idea3.collaborators.count).to eq(1)
    end

    it 'remove the user to collaborator list when user sign in' do
      sign_in(user)

      get :delete_collaborator, params: {id: idea3.id}
      idea3.reload

      expect(idea3.collaborators.count).to eq(0)
      expect(response.code).to eq('302')
    end


    it 'will not add the user to collaborator list when user not on the list' do
      sign_in(user2)

      get :delete_collaborator, params: {id: idea3.id}
      idea3.reload

      expect(idea3.collaborators.count).to eq(1)
    end
  end

  describe 'PATCH #love_idea' do
    it 'increase the love count by 1' do
      sign_in(user)

      patch :love_idea, params: { id: idea1.id }
      idea1.reload

      expect(idea1.loves.count).to eq(1)
    end

    it 'will decrease the love count by 1 if you alreay loved it' do
      sign_in(user)

      patch :love_idea, params: { id: idea1.id }
      patch :love_idea, params: { id: idea1.id }
      idea1.reload

      expect(idea1.loves.count).to eq(0)
    end

    it 'will not change the love count if you are not login' do
      patch :love_idea, params: { id: idea1.id }
      idea1.reload

      expect(idea1.loves.count).to eq(0)
    end

    it 'add to uers love list' do
      sign_in(user)

      patch :love_idea, params: {id: idea1.id}
      user.reload

      expect(user.loves).to eq([idea1.id])
    end

    it 'removes from users love list' do
      sign_in(user)

      patch :love_idea, params: {id: idea1.id}
      patch :love_idea, params: {id: idea1.id}
      user.reload

      expect(user.loves).to eq([])
    end
  end

  DatabaseCleaner.clean
end
