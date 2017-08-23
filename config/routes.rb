Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :ideas
  resources :suggestions, except: [:show, :edit]
  resources :comments, except: [:show, :edit]

  patch '/upvote', to: 'suggestions#up_vote', as: 'up_vote'
  patch '/downvote', to: 'suggestions#down_vote', as: 'down_vote'

  get '/trello', to: 'trello_api#show', as: 'show_boards'
  post '/trello/boards', to: 'trello_api#create_board', as: 'create_board'
  get '/auth', to: 'trello_api#get_token'
  get '/trello/new', to: 'trello_api#new', as: 'new_trello'
  get '*unmatched_route', to: 'errors#not_found'
end
