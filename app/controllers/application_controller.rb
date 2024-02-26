class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception # CSRF対策
  include SessionsHelper # 親クラスの本controllerで定義することで全てのcontrollerでsessionshelperが使える

  $days_of_the_week = %w{日 月 火 水 木 金 土}

   # beforeフィルター

  def set_user # paramsﾊｯｼｭからﾕｰｻﾞｰを取得。使いまわすため記述したもの。
    @user = User.find(params[:id])
  end
  
  def set_users
    @users = User.all
  end

  def superior_users
    @superior = User.where.not(role: ['上長A', '上長B'])
  end

  def logged_in_user # ﾛｸﾞｲﾝ済のﾕｰｻﾞｰか確認します
    unless logged_in? # ﾛｸﾞｲﾝしていなければ
      store_location # urlの記憶。sessions_helper参照
      flash[:danger] = "ログインしてください。"
      redirect_to login_url # ﾛｸﾞｲﾝ画面遷移
    end
  end

  def current_user?(user)
    user == current_user # =だと別のユーザーの情報見れてしまう
  end

  def correct_user # ｱｸｾｽしたﾕｰｻﾞｰが現在ﾛｸﾞｲﾝしているﾕｰｻﾞｰか確認します
    # @user = User.find(params[:id])の記述が不要になる理由は上記のset_userで定義しており、引数に@userを指定しているため。
    redirect_to(root_url) unless current_user?(@user) # ﾕｰｻﾞｰが現在ﾕｰｻﾞｰと一致しなければ、ﾄｯﾌﾟﾍﾟｰｼﾞに遷移。ｾｯｼｮﾝﾍﾙﾊﾟｰのﾒｿｯﾄﾞを使用。
  end
  
  def admin_user # ｼｽﾃﾑ管理権限所有かどうか判定します。
    redirect_to(root_url) unless current_user.admin? # 管理権限がなければﾄｯﾌﾟﾍﾟｰｼﾞに遷移
  end

  def set_one_month  # ﾍﾟｰｼﾞ出力前に1ヶ月分のﾃﾞｰﾀの存在を確認・ｾｯﾄします。
    @first_day = params[:date].nil? ? # dateが無い時本日月初を代入し、dateが有る時、その日を代入。
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します showｱｸｼｮﾝでは使わない為ﾛｰｶﾙ変数に代入している

    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)  # ﾕｰｻﾞｰに紐付く1ヶ月分のﾚｺｰﾄﾞを検索し取得します。
    # attendancesを複数形としていのはActivbeRecord特有の記法で、対象のﾓﾃﾞﾙ（今回はUserﾓﾃﾞﾙ）に紐付くﾓﾃﾞﾙという意味。UserﾓﾃﾞﾙとAttendanceﾓﾃﾞﾙは1対多の関係なので、attendancesとなる。
    # order(:worked_on)で昇順にしている。
    unless one_month.count == @attendances.count # 1ヶ月分の日付の件数と勤怠ﾃﾞｰﾀの件数が一致しない時
      ActiveRecord::Base.transaction do # ﾄﾗﾝｻﾞｸｼｮﾝを開始
        one_month.each { |day| @user.attendances.create!(worked_on: day) } # 繰り返し処理により、1ヶ月分の勤怠ﾃﾞｰﾀを生成します。
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end

  rescue ActiveRecord::RecordInvalid # ﾄﾗﾝｻﾞｸｼｮﾝによるｴﾗｰの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end

end
