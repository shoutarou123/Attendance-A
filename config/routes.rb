Rails.application.routes.draw do
  root 'static_pages#top' # get不要 static_paagesｺﾝﾄﾛｰﾗｰ topｱｸｼｮﾝ /でﾄｯﾌﾟﾍﾟｰｼﾞに遷移するようになる
  get '/signup', to: 'users#new'
  resources :users
end