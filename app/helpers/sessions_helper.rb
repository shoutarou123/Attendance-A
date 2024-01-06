module SessionsHelper
  
  def log_in(user) # 引数に渡されたユーザーオブジェクトでログインします。
    session[:user_id] = user.id # userのidレコードをsessionに入れる
  end

  def current_user # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
    if session[:user_id] # userのidレコードをsessionに入っていれば下の処理実行
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in? # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
    !current_user.nil? # 現在ログインしているuserがnilではない時ture、nilだったらfalse
  end
end
