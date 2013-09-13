ActionController::Routing::Routes.draw do |map|
  map.resources :articles

  map.resources :articles do |articles_map|
    articles_map.resources :comments
  end

  # LAST LINE
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
