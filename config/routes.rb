Rails.application.routes.draw do
  root "showings#index"
  
  get "/showing/:id", to: "showing#show"
  resources :showings
end
