class AttendancesController < ApplicationController

  # application_controllerで定義しているのでattendance_controllerでも使用できる
  before_action :set_user, only: :edit_one_month # @user = User.find(params[:id])使いまわし
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
  end

  private
    def attendances_params # 1ヶ月分の勤怠情報を扱います
      params.require(:user).permit(attendances: [:starede_at, :finished_at, :note])[:attendances]
    end
end
