Rails.application.routes.draw do
  root 'cocktails#index'
  mount Attachinary::Engine => "/attachinary"
  resources :cocktails, only: [:index, :show, :new,:edit,:update, :create, :destroy] do
    resources :doses, only: [:new, :create, :destroy], shallow: true
  end
end
