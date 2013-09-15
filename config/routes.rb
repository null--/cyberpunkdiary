ActionController::Routing::Routes.draw do |map|
  # Fixing routing problems
  map.connect "users/login", :controller => 'users', :action => 'login'
  map.connect "users/logout", :controller => 'users', :action => 'logout'
  map.connect "users/register", :controller => 'users', :action => 'register'
  map.connect "articles/:id/edit", :controller => "articles", :action => "edit"
  map.connect "votes/:score/:article_id/", :controller => "votes", :action => "edit"

  # Adding Controllers
  map.resources :articles
  map.resources :tags
  map.resources :users

  map.resources :articles do |articles_map|
    articles_map.resources :comments
    articles_map.resources :users
  end

  # LAST LINE / Standard
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
