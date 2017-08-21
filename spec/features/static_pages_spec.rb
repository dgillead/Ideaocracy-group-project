require 'rails_helper'

RSpec.feature 'Static pages', type: :feature do
  scenario 'visiting the home page' do
    visit '/'

    expect(page).to have_title 'Ideaocracy'
  end
end
