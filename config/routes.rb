Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :ideas
  resources :suggestions
  resources :comments

  patch '/upvote', to: 'suggestions#up_vote', as: 'up_vote'
  patch '/downvote', to: 'suggestions#down_vote', as: 'down_vote'

  get '/trello', to: 'trello_api#show', as: 'show_boards'
  post '/trello/boards', to: 'trello_api#create_board', as: 'create_board'
  get '/auth', to: 'trello_api#get_token'
  get '/trello/new', to: 'trello_api#new', as: 'new_trello'
end
