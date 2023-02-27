Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout' }
  get 'index', to: 'main#index'
  get 'gol', to: 'gol#gol', as: 'gol'

  get 'gol/generate', as: 'generate'
  post 'gol/generate'
  post 'gol/next_gen', as: 'next_gen'
  get 'gol/export', as: 'export'
  post 'gol/import', as: 'import'
  post 'gol/clear'
  get 'gol/clear'
  get 'gol/stall'
  get 'gol/start'
  post '/update_cell', to: 'gol#update_cell'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'main#index'
end
