class AttendancesController < ApplicationController

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil? # 出社が未登録であること
     if @attendance.update(started_at: Time.current.change(sec: 0)) # 秒数を0指定
      flash[:info] = "出社時間を登録しました。"
     else
      flash[:danger] = "出社時間登録に失敗しました。やり直してください。"
     end
    end
    redirect_to @user
  end
end
