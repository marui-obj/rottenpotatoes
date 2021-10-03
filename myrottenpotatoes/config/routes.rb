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
  post 'movies/search_tmdb' => 'tmdb#search_tmdb'
  get 'movies/:title/show_tmdb' => 'tmdb#show_tmdb' ,:as => 'movies_show_tmdb'
  get 'movies/:id/new_tmdb' => 'tmdb#new_tmdb', :as => 'movies_new_tmdb'
  post 'movies/:id/new_tmdb' => 'tmdb#create'
end
