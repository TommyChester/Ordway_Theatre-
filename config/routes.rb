Rails.application.routes.draw do
  resources :showings
  get "/showing", to: "showing#index"

end
