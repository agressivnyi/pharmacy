Rails.application.routes.draw do
  # Route for admin update
  patch 'admin/update/:id', to: 'admins#update'
  
  # Routes for user signup and login
  post 'signup', to: 'users#create'
  post 'login', to: 'users#login'
  
  # Route for registering and sending email
  post 'register_and_send_email', to: 'users#register_and_send_email'
  
  # Route for updating user information
  put 'auth/update_user/me', to: 'users#update_info_by_user'

  # Route for returning the current user's info
  get 'auth/me', to: 'users#me'
  
  # Nested resources for projects, stages, and tasks
  resources :projects do
    resources :stages do
      member do
        patch :change_status
      end
      resources :tasks do
        member do
          patch :change_status
        end
      end
    end
  end
end
