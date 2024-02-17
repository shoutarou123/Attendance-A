class AttendancesController < ApplicationController

  # application_controllerで定義しているのでattendance_controllerでも使用できる
  before_action :set_user, only: [:edit_one_month, :update_one_month, :edit_overtime_req, :edit_overtime_aprv, :update_overtime_req, :update_overtime_aprv, :edit_monthly_aprv] # @user = User.find(params[:id])使いまわし
  before_action :logged_in_user, only: [:update, :edit_one_month, :update_one_month, :edit_overtime_req, :edit_overtime_aprv, :update_overtime_req, :update_overtime_aprv, :edit_monthly_aprv] # ﾛｸﾞｲﾝしていなければ勤怠登録、勤怠編集ﾍﾟｰｼﾞ遷移できない
  before_action :superior_users, only: [:edit_one_month, :edit_overtime_req, :edit_overtime_aprv, :edit_monthly_aprv]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month, :edit_overtime_req, :edit_overtime_aprv, :update_overtime_req, :update_overtime_aprv, :edit_monthly_aprv, :update_monthly_req] # 管理権限者or現在ﾕｰｻﾞじゃないと勤怠更新、編集画面遷移、勤怠編集できない
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

  def edit_one_month # 勤怠編集 get
    @superior = User.where(superior: true).where.not(id: @current_user.id)
  end

  def update_one_month # 勤怠編集 patch
    flag = 0
    attendances_params.each do |id, item| # 4i=時 5i=分
      unless item["started_at(4i)"].blank? || item["started_at(5i)"].blank? || item["finished_at(4i)"].blank? || item["finished_at(5i)"].blank?
        attendance = Attendance.find(id)
        if item[:chg_next_day].present? && item[:chg_confirmed].present?
          unless attendance.chg_status == "申請中"
            flag += 1
            if attendance.b4_started_at.blank? && attendance.b4_finished_at.blank? # 初回の変更のみ保存
              attendance.b4_started_at = attendance.started_at
              attendance.b4_finished_at = attendance.finished_at
            end
            attendance.chg_status = "申請中"
            attendance.update!(item)
          end
        end
      end
    end
    if flag > 0
      flash[:success] = "勤怠変更申請を送信しました。"
      redirect_to user_url(date: params[:date])
    else
      flash[:danger] = "無効な入力データがあったため、更新をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
    end
  end
  
  def edit_overtime_req  #残業申請
    @attendance = @user.attendances.find_by(worked_on: params[:date])
    @superior = User.where(superior: true).where.not(id: @current_user.id)
    
    respond_to do |format|
      format.html { render partial: 'attendances/edit_overtime_req', locals: { attendance: @attendance } }
      format.turbo_stream
    end
  end
  
  def update_overtime_req
    overtime_req_params.each do |id, item|
      attendance = Attendance.find(id)
      if item["ended_at(4i)"].blank? || item["ended_at(5i)"].blank? || item[:confirmed_request].blank?
        flag = 1 if item[:approved] == '1'
      else
        flag = 1
      end
      if flag == 1
        attendance.overwork_chk = '0'
        attendance.overwork_status = "申請中"
        overtime_instructor = item["overtime_instructor"]
        attendance.update(item.merge(overtime_instructor: overtime_instructor))
        flash[:success] = "残業申請情報を送信しました。"
      else
        flash[:danger] = "未入力な項目があったため、申請をキャンセルしました。"
      end
    end
    redirect_to user_url # user showに遷移
  end
  
  def edit_overtime_aprv # 上長への残業申請
    @attendances = Attendance.where(confirmed_request: @user.name, overwork_status: "申請中") # confirmed_requestに名前があって、overwork_statusが申請中のものを探す
    @users = User.where(id: @attendances.select(:user_id)) # idに上記のattendancesのuser_idが入っているものを取得
    
    respond_to do |format|
      format.html { render partial: 'attendances/edit_overtime_aprv', locals: { attendance: @attendance } }
      format.turbo_stream
    end
  end
  
  def update_overtime_aprv
    flag = 0
    overtime_aprv_params.each do |id, item|
      if item[:overwork_chk] == '1' # 変更チェックがあれば
        unless item[:overwork_status] == "申請中" # 指示者確認が申請中でない場合
          flag += 1 # flagに1を足し上げる
          attendance = Attendance.find(id) # Attendance.idを取得
          if item[:overwork_status] == "なし" # 指示者確認がなしの場合
            attendance.ended_at = nil # 終了予定時間がnilになる
            attendance.task_description = nil # 業務処理内容がnilになる
          elsif item[:overwork_status] == "否認"
            attendance.ended_at = nil
            attendance.task_description = nil
          end
          attendance.update(item) # attendance(item)を更新する
        end
      end
      if flag > 0
        flash[:success] = "残業申請を更新しました。"
      else
        flash[:danger] = "残業申請の更新に失敗しました。"
      end
      redirect_to user_url(date: params[:date])
    end
  end
  
  def update_monthly_req # 1か月分の勤怠申請 patch
    flag = 0
    monthly_req_params.each do |id, item|
      if item[:aprv_confirmed].present?
        flag += 1
        attendance = Attendance.find(id)
        attendance.aprv_status = "申請中"
        attendance.update(item)
      end
      if flag > 0
        flash[:success] = "１カ月分の勤怠申請を送信しました。"
      else
        flash[:danger] = "１カ月分の勤怠申請に失敗しました。"
      end
      redirect_to user_url(date: params[:date])
    end
  end
  
  def edit_monthly_aprv # 上長への１カ月分の勤怠申請 get
    @attendances = Attendance.where(aprv_confirmed: @user.name, aprv_status: "申請中") # confirmed_requestに名前があって、overwork_statusが申請中のものを探す
    @users = User.where(id: @attendances.select(:user_id)) # idに上記のattendancesのuser_idが入っているものを取得
    
    respond_to do |format|
      format.html { render partial: 'attendances/edit_monthly_aprv', locals: { attendance: @attendance } }
      format.turbo_stream
    end
  end
  
  def update_monthly_aprv
    flag = 0
    monthly_aprv_params.each do |id, item|
      if item[:aprv_chk] == "1"
        unless[:aprv_status] == "申請中"
          flag += 1
          attendance = Attendance.find(id)
          if item[:aprv_status] == "なし"
            attendance.aprv_status = nil
            attendance.aprv_confirmed = nil
          end
          attendance.update(item)
        end
      end
    end
    if flag > 0
      flash[:success] = "１カ月分の勤怠申請を更新しました。"
    else
      flash[:danger] = "１カ月分の勤怠申請の更新に失敗しました。"
    end
    redirect_to user_url
  end

  private
    def attendances_params # 1ヶ月分の勤怠情報を扱います
      params.require(:user).permit(attendances: [:started_at, :finished_at, :chg_next_day, :note, :chg_confirmed])[:attendances]
    end
    
    def overtime_req_params
      params.require(:user).permit(attendances: [:ended_at, :approved, :task_description, :confirmed_request])[:attendances]
    end
    
    def overtime_aprv_params
      params.require(:user).permit(attendances: [:overwork_status, :overwork_chk])[:attendances]
    end

    def monthly_req_params
      params.require(:user).permit(attendances: :aprv_confirmed)[:attendances]
    end
    
    def monthly_aprv_params
      params.require(:user).permit(attendances: [:aprv_chk, :aprv_status])[:attendances]
    end
      
    # beforeフィルター
    def admin_or_correct_user # 管理権限者、または現在ﾛｸﾞｲﾝしているﾕｰｻﾞｰを許可します。
      @user = User.find(params[:user_id]) if @user.blank? # @userが空だったらuser_idを探して代入
      unless current_user?(@user) || current_user.admin? # 現在ﾕｰｻﾞｰじゃない又は管理権限が無い場合
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
    end
end
