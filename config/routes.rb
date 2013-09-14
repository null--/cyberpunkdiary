ActionController::Routing::Routes.draw do |map|
  map.connect "users/login", :controller => 'users', :action => 'login'
  map.connect "users/logout", :controller => 'users', :action => 'logout'
  map.connect "users/register", :controller => 'users', :action => 'register'

  map.resources :articles
  map.resources :tags
  map.resources :users

  map.resources :articles do |articles_map|
    articles_map.resources :comments
    articles_map.resources :users
  end

  map.connect "users/login", :controller => 'users', :action => 'login'

  # LAST LINE
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
