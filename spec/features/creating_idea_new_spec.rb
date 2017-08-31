require 'rails_helper'

RSpec.feature 'post ideas', :type => :feature do
  describe 'post idea process' do
    before :each do
      user = User.create(email: 'jon@email.com', first_name: 'Jon', last_name: 'Young', username: 'jon', password: '123123', password_confirmation: '123123')
    end
  end

  it "logs me in" do
    visit '/ideas/new' do
    fill_in('Title', with: 'A new idea')
    fill_in('Tag', with: 'Great')
    fill_in('Summary', with: 'That is very useful') 
    end
  
    expect(page).to have_content 'Idea'

  end

  
end   