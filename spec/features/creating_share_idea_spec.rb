require 'rails_helper'

RSpec.feature 'share idea', :type => :feature do
  describe "the sharing idea process"
    before :each do
      Idea.create(title: 'Life Alert', summary: 'It is a device that helps elderly when they fall and they cannot get up.')
    end

    it "post my idea" do
      visit '/ideas/new'
      visit 'new_idea_path' do
        fill_in 'Title', with: 'Life Alert'
        fill_in 'Summary', with: 'It is a device that helps elderly when they fall and they cannot get up.'
      end

      expect(page).to have_content 'Home'
      expect(page).to have_content 'About'
      expect(page).to have_content 'Share idea'
      expect(page).to have_content 'Account Setting'
    end
end
