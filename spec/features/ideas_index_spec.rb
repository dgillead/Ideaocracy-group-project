require 'rails_helper'

RSpec.feature 'ideas', type: :feature do
  scenario 'no ideas' do
    
    visit '/ideas'

    expect(page).to have_content 'Nothing yet'
    expect(page).to_not have_content 'Discuss Idea'
  end

  scenario 'ideas' do
    user = User.create(email: 'jon@email.com', first_name: 'Jon', last_name: 'Young', username: 'jon', password: '123123', password_confirmation: '123123')
    Idea.create(user_id: user.id, title: 'some title', summary: 'some summary')
    
    visit '/ideas'
    click_on 'Discuss Idea'

    expect(page).to have_content 'Have a good suggestion?'
  end
end

