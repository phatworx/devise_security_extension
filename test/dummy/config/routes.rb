RailsApp::Application.routes.draw do
  devise_for :users
  resources :foos

  root to: 'foos#index'
end