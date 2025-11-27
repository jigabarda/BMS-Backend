Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users,
                 controllers: { sessions: 'api/v1/users/sessions', registrations: 'api/v1/users/registrations' },
                 path: 'auth',
                 defaults: { format: :json }

      resources :broadcasts, only: [:index, :create, :show] do
        member do
          post :send_broadcast
        end
      end

      resources :devices, only: [:create, :index, :destroy]
    end
  end

  # ActionCable mount (for dev)
  mount ActionCable.server => '/cable'
end
