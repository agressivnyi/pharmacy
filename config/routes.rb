Rails.application.routes.draw do
  patch 'admin/update/:id', to: 'admins#update'
  post 'signup', to: 'users#create'
  post 'login', to: 'users#login'
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
