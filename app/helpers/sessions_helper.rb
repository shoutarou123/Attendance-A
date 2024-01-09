module SessionsHelper
  
  def log_in(user) # 引数に渡されたﾕｰｻﾞｰｵﾌﾞｼﾞｪｸﾄでﾛｸﾞｲﾝします。
    session[:user_id] = user.id # userのidﾚｺｰﾄﾞをsessionに入れる
  end

  def remember(user) # 永続的ｾｯｼｮﾝを記憶します（Userﾓﾃﾞﾙを参照）
    user.remember
    cookies.permanent.signed[:user_id] = user.id # user.idを暗号化して永続ｸｯｷｰに保存
    cookies.permanent[:remember_token] = user.remember_token # ﾄｰｸﾝを永続ｸｯｷｰに保存
  end

  def forget(user) # 永続的ｾｯｼｮﾝを破棄します
    user.forget # Userﾓﾃﾞﾙ参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out # ｾｯｼｮﾝと@current_userを破棄します
    forget(current_user)
    session.delete(:user_id) # ｾｯｼｮﾝからﾕｰｻﾞｰIDを削除
    @current_user = nil # current_userﾒｿｯﾄﾞによって@current_userに代入されたﾕｰｻﾞｰｵﾌﾞｼﾞｪｸﾄ削除
  end

  def current_user # 現在ﾛｸﾞｲﾝ中のﾕｰｻﾞｰがいる場合ｵﾌﾞｼﾞｪｸﾄを返します。
    if (user_id = session[:user_id]) # userのidﾚｺｰﾄﾞをsessionに入っていれば下の処理実行
      @current_user ||= User.find_by(id: user_id) # @current_userがnilだったら、Userの中のidカラムの中のsessionに入っているuser.idを@current_userに代入。nilじゃなかったらそのまま@current_userを使用。
    elsif (user_id = cookies.signed[:user_id]) # session[:user_id] が存在しない場合
      user = User.find_by(id: user_id) # 代わりに cookies.signed[:user_id] をﾁｪｯｸします
      if user && user.authenticated?(cookies[:remember_token]) # 特定されたﾕｰｻﾞｰが存在し、かつそのﾕｰｻﾞｰが authenticated?(cookies[:remember_token]) を通過した場合
        log_in user # そのﾕｰｻﾞｰでﾛｸﾞｲﾝし
        @current_user = user # @current_user にそのﾕｰｻﾞｰをｾｯﾄします。
      end
    end
  end

  def current_user?(user) # ﾕｰｻﾞｰがﾛｸﾞｲﾝ済ﾕｰｻﾞｰであればtrueを返す
    user == current_user
  end

  def logged_in? # 現在ﾛｸﾞｲﾝ中のﾕｰｻﾞｰがいればtrue、そうでなければfalseを返します。
    !current_user.nil? # 現在ﾛｸﾞｲﾝしているuserがnilではない時ture、nilだったらfalse
  end

  def redirect_back_or(default_url) # 記憶しているURL(又はﾃﾞﾌｫﾙﾄURL)にﾘﾀﾞｲﾚｸﾄする
    redirect_to(session[:forwarding_url] || default_url) # session[:forwarding_url]がtrueの時そこへ遷移、nilならﾃﾞﾌｫﾙﾄに遷]
    session.delete(:forwarding_url) # 指定のﾊﾟｽに移動した後に:forwarding_urlを削除。次回ﾛｸﾞｲﾝした時に保存していたURLに飛ぶことを防いでいる。
  end

  def store_location # ｱｸｾｽしようとしたURLを記憶する
    session[:forwarding_url] = request.original_url if request.get? # getﾘｸｴｽﾄの時だけ一時的ｾｯｼｮﾝへurlを格納。
  end
end
