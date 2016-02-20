Rails.application.routes.draw do
	resources :questions do
    collection do
      get :autocomplete
    end
  end

  root to: 'questions#index'
end
