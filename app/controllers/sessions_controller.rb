class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) # emailカラムの中のparams[:sesseion]の中の[:email]を探して小文字化する
    if user && user.authenticate(params[:session][:password]) # 上記のemailかつそのuserのsessionの中のpasswordどちらもtrueであれば処理実行
      log_in user # session_helper参照
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) # params[:session][:remember_me]が1の時ﾕｰｻﾞｰ情報を記憶し、1以外の時ﾕｰｻﾞｰ情報を記憶しない。
      if current_user.admin?
        redirect_to users_url
      else
      redirect_back_or user # 記憶したURLに遷移 userを指定することでﾃﾞﾌｫﾙﾄURLとしている。 sessions_helper参照
      end
    else
      flash.now[:danger] = '認証に失敗しました。'
      render 'new', status: :unprocessable_entity # ログインページに遷移する。status: :unprocessable_entityがないとRails7はエラー表示されない。
    end
  end

  def destroy
    log_out if logged_in? # ﾛｸﾞｲﾝ中の場合のみﾛｸﾞｱｳﾄ処理を実行します。(sessions_helper参照)
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url # ﾄｯﾌﾟ画面に遷移
  end
end