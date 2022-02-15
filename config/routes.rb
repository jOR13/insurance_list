Rails.application.routes.draw do
  root "insurance#index"
  resources :insurance
end
