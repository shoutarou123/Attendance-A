Rails.application.routes.draw do
  root 'static_pages#top' # get不要 static_paagesｺﾝﾄﾛｰﾗｰ topｱｸｼｮﾝ /でﾄｯﾌﾟﾍﾟｰｼﾞに遷移するようになる
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    collection { post :import } # CSVｲﾝﾎﾟｰﾄ用
    member do
      get 'attendance_list'
      get 'attendance_log'  #勤怠ログ
      get 'attendances/edit_one_month' #勤怠編集画面
      patch 'attendances/update_one_month' # 勤怠編集更新機能
      get 'attendances/edit_chg_req'  #上長への勤怠編集申請
      patch 'attendances/update_chg_req'
      get 'attendances/edit_overtime_req' #残業申請
      patch 'attendances/update_overtime_req'
      get 'attendances/edit_overtime_aprv' #上長への残業申請
      patch 'attendances/update_overtime_aprv'
      patch 'attendances/update_monthly_req'  #一ヶ月分の勤怠申請
      get 'attendances/edit_monthly_aprv' #上長への一ヶ月分の勤怠申請
      patch 'attendances/update_monthly_aprv'
      get 'working' # 出勤中ﾍﾟｰｼﾞ
      get 'edit_basic_info' # 勤務時間変更ﾍﾟｰｼﾞ
      patch 'update_basic_info' # 勤務時間変更機能
    end
    resources :attendances, only: :update # updateｱｸｼｮﾝのみで良いためこの記述。
  end
   resources :base_points
end