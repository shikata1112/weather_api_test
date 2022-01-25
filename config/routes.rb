Rails.application.routes.draw do
  namespace :api do
    resources :weathers, only: [:index]
  end
end
