module SessionsHelper
  
  def log_in(user) # 引数に渡されたﾕｰｻﾞｰｵﾌﾞｼﾞｪｸﾄでﾛｸﾞｲﾝします。
    session[:user_id] = user.id # userのidﾚｺｰﾄﾞをsessionに入れる
  end

  def log_out
    session.delete(:user_id) # ｾｯｼｮﾝからﾕｰｻﾞｰIDを削除
    @current_user = nil # current_userﾒｿｯﾄﾞによって@current_userに代入されたﾕｰｻﾞｰｵﾌﾞｼﾞｪｸﾄ削除
  end

  def current_user # 現在ﾛｸﾞｲﾝ中のﾕｰｻﾞｰがいる場合ｵﾌﾞｼﾞｪｸﾄを返します。
    if session[:user_id] # userのidﾚｺｰﾄﾞをsessionに入っていれば下の処理実行
      @current_user ||= User.find_by(id: session[:user_id]) # @current_userがnilだったら、Userの中のidカラムの中のsessionに入っているuser.idを@current_userに代入。nilじゃなかったらそのまま@current_userを使用。
    end
  end

  def logged_in? # 現在ﾛｸﾞｲﾝ中のﾕｰｻﾞｰがいればtrue、そうでなければfalseを返します。
    !current_user.nil? # 現在ﾛｸﾞｲﾝしているuserがnilではない時ture、nilだったらfalse
  end
end
