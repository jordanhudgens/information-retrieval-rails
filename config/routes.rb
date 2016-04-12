Rails.application.routes.draw do
  devise_for :users
	resources :questions do
    collection do
      get :autocomplete
    end
  end

  get 'history', to: 'questions#history', as: 'history'

  root to: 'questions#index'
end
