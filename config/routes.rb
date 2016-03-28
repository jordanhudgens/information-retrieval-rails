Rails.application.routes.draw do
  devise_for :users
	resources :questions do
    collection do
      get :autocomplete
    end
  end

  root to: 'questions#index'
end
