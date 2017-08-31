require 'rails_helper'

RSpec.feature 'login', :type => :feature do
  describe "the signin process"
    before :each do
      User.create(email: 'user@example.com', password: 'password')
    end

    it "logs me in" do
      visit '/sessions/new'
      visit 'new_user_session_path' do
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'password'
      end

      expect(page).to have_link 'Login'
      expect(page).to have_link 'Ideas'
      expect(page).to have_link 'Register'
      expect(page).to have_content 'Ideaocracy'
    end


end
