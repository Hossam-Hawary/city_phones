Rails.application.routes.draw do
  namespace :api, path: '/api' do
    resources :phone_numbers, only: [:create]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
