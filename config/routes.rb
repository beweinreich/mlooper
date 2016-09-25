Rails.application.routes.draw do
  devise_for :users

  get '/conversations/count', to: "conversations#count"
  post '/sendgrid-event', to: proc { [200, {}, ['']] }
  get '/users/confirm', to: "users#confirm"

  resources :users, only: [:show, :update]
  resources :conversations
  resources :replacements

  mount_griddler

  root 'pages#home'

  end
