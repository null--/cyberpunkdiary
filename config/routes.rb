ActionController::Routing::Routes.draw do |map|
  # Custom routings
  map.connect "/", :controller => "mypage", :action => "index"

  map.connect "captcha/generate", :controller => 'captcha', :action => 'generate'
  
  map.connect "tags/:id/:page", :controller => 'tags', :action => 'show'

  map.connect "recovery/", :controller => "users", :action => "recovery"
  map.connect "users/:id/edit", :controller => "users", :action => "edit"
  map.connect "users/:id/:page", :controller => 'users', :action => 'show'
  map.connect "users/login", :controller => 'users', :action => 'login'
  
  # map.connect "users/register", :controller => 'users', :action => 'register'
  # map.connect "users/edit", :controller => 'users', :action => 'edit'
  map.connect "logout/:id", :controller => 'users', :action => 'logout'
  
  map.connect "votes/:score/:article_id/", :controller => "votes", :action => "edit"

  map.connect "admin/userlist/:page", :controller => "admin", :action => "userlist"

  map.connect "articles/page/:order/:dir/:page", :controller => "articles", :action => "index"
  
  map.connect "comments/destroy/:id", :controller => "comments", :action => "destroy"

  map.connect "rss/articles", :controller => "articles", :action => "diary_rss"
  map.connect "rss/article/:id", :controller => "articles", :action => "comment_rss"
  map.connect "rss/user/:id", :controller => "users", :action => "user_rss"
  map.connect "rss/tag/:id", :controller => "tags", :action => "tag_rss"
  
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
