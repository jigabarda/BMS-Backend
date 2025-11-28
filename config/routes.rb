Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users,
             defaults: { format: :json },
             path: '',
             path_names: {
               sign_in: 'auth/sign_in',
               sign_out: 'auth/sign_out',
               registration: 'auth'
             },
             controllers: {
               sessions: 'api/v1/users/sessions',
               registrations: 'api/v1/users/registrations'
             }

  namespace :api do
    namespace :v1 do
      get "users/me", to: "users#me"

      resources :devices, only: [:index, :create, :destroy]
      resources :broadcasts, only: [:index, :create, :show] do
        post :send_broadcast, on: :member
      end
    end
  end
end
