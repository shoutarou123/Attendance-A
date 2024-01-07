class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) # emailカラムの中のparams[:sesseion]の中の[:email]を探して小文字化する
    if user && user.authenticate(params[:session][:password]) # 上記のemailかつそのuserのsessionの中のpasswordどちらもtrueであれば処理実行
      log_in user # session_helper参照
      remember user # session_helper参照
      redirect_to user
    else
      flash.now[:danger] = '認証に失敗しました。'
      render :new # ログインページに遷移する。status: :unprocessable_entityがないとRails7はエラー表示されない。
    end
  end

  def destroy
    log_out # ﾛｸﾞｱｳﾄしたら(sessions_helper参照)
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url # ﾄｯﾌﾟ画面に遷移
  end
end