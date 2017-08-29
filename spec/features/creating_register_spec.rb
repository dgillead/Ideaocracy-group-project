require 'rails_helper'

RSpec.feature 'register', :type => :feature do
  describe "the register process"
    before :each do
      User.create(email: 'user@example.com', first_name: 'Jon', last_name: 'Young', username: 'lilJon', password: 'password', password_confirmation: 'password')
    end

    it "registers me" do
      visit '/registrations/new'
      visit 'new_user_registration_path' do
        fill_in 'Email', with: 'user@example.com'
        fill_in 'First Name', with: 'Jon'
        fill_in 'Last Name', with: 'Young'
        fill_in 'Username', with: 'lilJon'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
      end

      expect(page).to have_content 'Login'
      expect(page).to have_content 'Ideas'
      expect(page).to have_content 'Register'
      expect(page).to have_content 'Ideaocracy'
    end
end
