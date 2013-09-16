ActionController::Routing::Routes.draw do |map|
  # Custom routings
  map.connect "/", :controller => "mypage", :action => "index"

  map.connect "captcha/generate", :controller => 'captcha', :action => 'generate'
  
  map.connect "users/login", :controller => 'users', :action => 'login'
  map.connect "users/logout", :controller => 'users', :action => 'logout'
  map.connect "users/register", :controller => 'users', :action => 'register'
  map.connect "users/edit", :controller => 'users', :action => 'edit'

  map.connect "votes/:score/:article_id/", :controller => "votes", :action => "edit"

  map.connect "admin/userlist/", :controller => "admin", :action => "userlist"
  map.connect "admin/articlelist", :controller => "admin", :action => "articlelist"

  # Adding Controllers
  map.resources :articles
  map.resources :tags
  map.resources :users
  map.resources :admin

  map.resources :articles do |articles_map|
    articles_map.resources :comments
    articles_map.resources :users
  end

  map.connect "articles/:id/edit", :controller => "articles", :action => "edit"

  # LAST LINE / Standard
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
