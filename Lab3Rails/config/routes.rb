Rails.application.routes.draw do
  root "articles#index"
  devise_for :users
  resources :articles do
    resources :comments
    member do
      post 'report'
    end
  end
end
