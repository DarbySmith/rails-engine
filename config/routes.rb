Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/items/find', to: 'search_items#show'
      get '/merchants/find_all', to: 'search_merchants#index'
      get '/items/:id/merchant', to: 'item_merchant#show'
      
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchant_items'
      end
      
      resources :items do
        resources :merchant, to: 'item_merchant#show'
      end
    end
  end
end
