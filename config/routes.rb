Rails.application.routes.draw do
  root "listings#index"
  resources :listings, only: %i[index show new create] do
    resources :bids, only: :create
  end
  get "stats", to: "stats#index"
end
