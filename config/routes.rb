Rails.application.routes.draw do
  
  root 'static_pages#top' # get不要 static_paagesｺﾝﾄﾛｰﾗｰ topｱｸｼｮﾝ /でﾄｯﾌﾟﾍﾟｰｼﾞに遷移するようになる
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
    end
  end
end