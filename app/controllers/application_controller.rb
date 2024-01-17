class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception # CSRF対策
  include SessionsHelper # 親クラスの本controllerで定義することで全てのcontrollerでsessionshelperが使える

  $days_of_the_week = %w{日 月 火 水 木 金 土}

  def set_one_month  # ﾍﾟｰｼﾞ出力前に1ヶ月分のﾃﾞｰﾀの存在を確認・ｾｯﾄします。
    @first_day = Date.current.beginning_of_month
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します showｱｸｼｮﾝでは使わない為ﾛｰｶﾙ変数に代入している
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day)  # ﾕｰｻﾞｰに紐付く1ヶ月分のﾚｺｰﾄﾞを検索し取得します。
    # attendancesを複数形としていのはActivbeRecord特有の記法で、対象のﾓﾃﾞﾙ（今回はUserﾓﾃﾞﾙ）に紐付くﾓﾃﾞﾙという意味。UserﾓﾃﾞﾙとAttendanceﾓﾃﾞﾙは1対多の関係なので、attendancesとなる。
    unless one_month.count == @attendances.count # 1ヶ月分の日付の件数と勤怠ﾃﾞｰﾀの件数が一致しない時
      ActiveRecord::Base.transaction do # ﾄﾗﾝｻﾞｸｼｮﾝを開始
        one_month.each { |day| @user.attendances.create!(worked_on: day) } # 繰り返し処理により、1ヶ月分の勤怠ﾃﾞｰﾀを生成します。
      end
    end

  rescue ActiveRecord::RecordInvalid # ﾄﾗﾝｻﾞｸｼｮﾝによるｴﾗｰの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end

end
