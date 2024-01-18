class AttendancesController < ApplicationController

  # application_controllerで定義しているのでattendance_controllerでも使用できる
  before_action :set_user, only: [:edit_one_month, :update_one_month] # @user = User.find(params[:id])使いまわし
  before_action :logged_in_user, only: [:update, :edit_one_month] # ﾛｸﾞｲﾝしていなければ勤怠登録、勤怠編集ﾍﾟｰｼﾞ遷移できない
  before_action :set_one_month, only: :edit_one_month # ﾍﾟｰｼﾞ出力前に1ヶ月分のﾃﾞｰﾀの存在を確認・ｾｯﾄを勤怠編集ﾍﾟｰｼﾞに適用

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil? # 出社が未登録であること
     if @attendance.update(started_at: Time.current.change(sec: 0)) # 秒数を0指定
      flash[:info] = "出社時間を登録しました。"
     else
      flash[:danger] = "出社時間登録に失敗しました。やり直してください。"
     end
    elsif @attendance.finished_at.nil?
      if @attendance.update(finished_at: Time.current.change(sec: 0))
        flash[:info] = "退社時間を登録しました。"
      else
        flash[:danger] = "退社時間登録に失敗しました。やり直してください。"
      end
    end
    redirect_to @user
  end

  def edit_one_month
  end

  def update_one_month
    ActiveRecord::Base.transaction do # ﾄﾗﾝｻﾞｸｼｮﾝを開始しますActiveRecord::Base.transaction do から end までﾄﾗﾝｻﾞｸｼｮﾝを開始している。これは、一連のﾃﾞｰﾀﾍﾞｰｽ操作が全て成功するかどれか1つでもｴﾗｰが発生した場合には全ての操作をﾛｰﾙﾊﾞｯｸする仕組みです。ﾄﾗﾝｻﾞｸｼｮﾝ内の操作が成功した場合はｺﾐｯﾄされます。
      attendances_params.each do |id, item| # attendances_params というﾃﾞｰﾀ構造から、各勤怠情報のIDと更新情報を取り出して、それぞれのﾃﾞｰﾀに対して以下の処理を実行します。
        attendance = Attendance.find(id) # idﾚｺｰﾄﾞに基づいたAttendance情報を取得
        attendance.update!(item) # 更新に成功するとそのまま続行し、失敗した場合は例外を発生させます。!をつけている場合はfalseでは無く例外処理を返します
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # 例外発生時の処理
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date]) # 勤怠編集ﾍﾟｰｼﾞに遷移
  end

  private
    def attendances_params # 1ヶ月分の勤怠情報を扱います
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
end
