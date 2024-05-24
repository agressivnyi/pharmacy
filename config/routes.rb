Rails.application.routes.draw do
  patch 'admin/update/:id', to: 'admins#update'
  post 'signup', to: 'users#create'
  post 'login', to: 'users#login'
end