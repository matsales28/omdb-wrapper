Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get '/movies/:id', to: 'movies#search_by_id', as: :movie
      get '/movies', to: 'movies#search_by_title'
      get '/search', to: 'movies#multiple_search'
    end
  end
end
