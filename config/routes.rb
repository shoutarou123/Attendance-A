Rails.application.routes.draw do
  
  root 'static_pages#top' # get不要 static_paagesｺﾝﾄﾛｰﾗｰ topｱｸｼｮﾝ /でﾄｯﾌﾟﾍﾟｰｼﾞに遷移するようになる
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    collection {post :import} # CSVｲﾝﾎﾟｰﾄ用
    member do
      get 'working' # 出勤中ﾍﾟｰｼﾞ
      get 'edit_basic_info' # 勤務時間変更ﾍﾟｰｼﾞ
      patch 'update_basic_info' # 勤務時間変更機能
      get 'attendances/edit_one_month' # 勤怠ﾍﾟｰｼﾞ
      patch 'attendances/update_one_month' # 勤怠編集更新機能
    end
    resources :attendances, only: :update # updateｱｸｼｮﾝのみで良いためこの記述。
  end
end