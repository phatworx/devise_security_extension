RailsApp::Application.routes.draw do
  devise_for :users

  match '/users/password_expired' => 'devise/password_expired#update', via: [:put, :patch]
  get '/users/password_expired' => 'devise/password_expired#show'

  root to: 'home#index'
end
