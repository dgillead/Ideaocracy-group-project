Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'

  resources :ideas
  resources :suggestions, except: [:show, :edit]
  resources :comments, except: [:show, :edit]

  get '/search', to: 'ideas#search_tags'

  patch '/upvote', to: 'suggestions#up_vote'
  patch '/downvote', to: 'suggestions#down_vote'
  patch '/love_idea', to: 'ideas#love_idea'

  get '/trello', to: 'trello_api#show', as: 'show_boards'
  post '/trello/boards', to: 'trello_api#create_board', as: 'create_board'
  get '/auth', to: 'trello_api#get_token'
  get '/trello/new', to: 'trello_api#new', as: 'new_trello'
  get '/collaborate/new', to: 'ideas#new_collaborator', as: 'new_collaborator'
  get '/collaborate/delete', to: 'ideas#delete_collaborator', as: 'remove_collaborator'

  get '/users/index', to: 'users#index', as: 'show_user'
  get '/users/ideas', to: 'users#ideas', as: 'show_user_ideas'
  get '/users/suggestions', to: 'users#suggestions', as: 'show_user_suggestions'
  get '/users/comments', to: 'users#comments', as: 'show_user_comments'
  get '/users/loves', to: 'users#loves', as:'show_user_loves'

  get '/suggestions/vote_count', to: 'suggestions#vote_count'

  get '/search', to: 'search#search', as:'search'

  get '*unmatched_route', to: 'errors#not_found'
end
