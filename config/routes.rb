Rails.application.routes.draw do
  root "showings#index"
  get "/showing", to: "showings#index"
  resources :showings
end
