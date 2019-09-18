Rails.application.routes.draw do
  get 'pages/parser'
  root to: 'pages#parser'

  resources :pages do
    collection { post :upload }
  end
end
