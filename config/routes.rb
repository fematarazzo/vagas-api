Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :vagas, only: [ :index, :show ]
    end
  end
end
