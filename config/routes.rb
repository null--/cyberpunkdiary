ActionController::Routing::Routes.draw do |map|
  map.resources :articles
  map.resources :tags
  map.resources :users

  map.resources :articles do |articles_map|
    articles_map.resources :comments
    articles_map.resources :users
  end

  # LAST LINE
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
