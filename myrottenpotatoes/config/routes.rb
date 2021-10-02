Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :movies do
    resources :reviews
  end
  root :to => redirect('/movies')

  get '/auth/:provider/callback' => 'sessions#create'
  post 'logout' => 'sessions#destroy'
  get 'auth/failure' => 'sessions#failure'
  get 'auth/google_oauth2', :as => 'login'
  post 'movies/search_tmdb' => 'movies#search_tmdb'
  get 'movies/:title/add_tmdb' => 'movies#add_tmdb' ,:as => 'movies_add_tmdb'
end
