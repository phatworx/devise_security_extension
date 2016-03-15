RailsApp::Application.routes.draw do
  devise_for :users

  devise_for :captcha_users, only: [:sessions], controllers: { sessions: "captcha/sessions" }
  devise_for :security_question_users, only: [:sessions, :unlocks], controllers: { unlocks: "security_question/unlocks" }

  resources :foos

  root to: 'foos#index'
end
