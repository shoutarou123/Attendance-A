class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :attendance_log] # correct_userのbefore_actionで同じ@userが2回使用されてしまうため本ﾒｿｯﾄﾞを各ｱｸｼｮﾝに定義している
  before_action :set_users, only: :show
  before_action :logged_in_user, only: [:index, :show, :working, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :attendance_log] # ﾛｸﾞｲﾝしていなければ一覧画面、出勤中一覧画面、編集画面、編集更新、削除、基本情報編集できない
  before_action :superior_users, only: [:show]
  before_action :correct_user, only: :show # 現在ﾕｰｻﾞｰの情報のみ変更可。違うﾕｰｻﾞｰの変更不可。
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info] # 管理権限がないと削除、基本情報編集できない。
  before_action :set_one_month, only: :show # ﾍﾟｰｼﾞ出力前に1ヶ月分のﾃﾞｰﾀの存在を確認・ｾｯﾄ showｱｸｼｮﾝ実行前に発動

  def index
    # @users = User.paginate(page: params[:page]) # User.allから変更。paginateではｷｰが:pageで値がﾍﾟｰｼﾞ番号のﾊｯｼｭを引数にとります。User.paginateは:pageﾊﾟﾗﾒｰﾀに基づき、ﾃﾞｰﾀﾍﾞｰｽから一塊のﾃﾞｰﾀを取得する。ﾃﾞﾌｫﾙﾄは30件。
    @users = User.page(params[:page]).per(30) # kaminariでのpeginateに変更
  end

  def import
    if params[:file].present? && File.extname(params[:file].original_filename) == ".csv" # ﾌｧｲﾙが存在すること。かつｱｯﾌﾟﾛｰﾄﾞされたﾌｧｲﾙ名の拡張子が.csvである時
      flash[:success] = 'CSVファイルを読み込みました。'
      User.import(params[:file])
      redirect_to users_url # ﾕｰｻﾞｰ一覧へ遷移
    else
      flash[:danger] = 'CSVファイルを選択してください。'
      redirect_to users_url # ﾕｰｻﾞｰ一覧へ遷移
    end
  end

  def working
    @user_info_list = [] # @user_info_listの初期化。空のスペースを作成しその後代入できるようにしている。user.all定義し条件該当ﾃﾞｰﾀだけ取得すると最後に該当したものだけ取得することになってしまう。
      User.all.each do |user|
        attendance = user.attendances.find_by(worked_on: Date.current) # ユーザーの特定の日の出勤データを取得
          if attendance.present? && attendance.started_at.present? && attendance.finished_at.blank?  # started_at が存在し、finished_at が存在しないデータだけを取得
            user_info = { name: user.name, employee_number: user.employee_number }
            @user_info_list << user_info # user_infoを初期化した@user_info_listに代入しviewsで使用できるようにしている。
          end
      end
  end

  def show
    @current_user = current_user
    @superior = User.where(superior: true).where.not(id: @current_user.id)
    @attendance = @user.attendances.find_by(worked_on: @first_day)
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)   # 該当日の残業申請取得
    @worked_sum = @attendances.where.not(started_at: nil).count # 出社が何も無いじゃない数
    @first_day = Date.current.beginning_of_month # 現在日付の月初
    @last_day = @first_day.end_of_month # 上記の月の末日
    @monthly_count = Attendance.where(aprv_confirmed: @user.name, aprv_status: "申請中").count # 上長への１カ月分の勤怠申請の件数
    @month_count = Attendance.where(chg_confirmed: @user.name, chg_status: "申請中").count # 勤怠変更のお知らせ件数
    @aprv_count = Attendance.where(confirmed_request: @user.name, overwork_status: "申請中").count # 残業申請のお知らせ件数
    @overtime_instructor = @attendances.first.overtime_instructor if @attendances.first
    
    respond_to do |format|
      format.html
      format.csv { send_data User.generate_csv(@attendances), filename: "#{@user.name}_#{Time.zone.now.strftime('%Y年%m月分')}.csv" }
    end   
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save # 保存成功
      log_in @user # 保存成功後、ログインします。
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user # redirect_to user_url(@user)と同じ意味
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user # redirect_to user_url(@user)と同じ意味
    else
      flash[:danger] = "ユーザー情報を更新できませんでした。"
      redirect_to @user
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url # 一覧へ遷移
  end

  def edit_basic_info
    @user = User.find(params[:id])
  
    respond_to do |format|
      format.html { render partial: 'users/edit_basic_info', locals: { user: @user } }
      format.turbo_stream
    end
  end

  def update_basic_info
  end

  def attendance_log
    @attendances = @user.attendances.where(chg_status: "承認").order(:worked_on)
  
    if params["select_year(1i)"].present? && params["select_month(2i)"].present?
      @first_day = (params["select_year(1i)"] + "-" + params["select_month(2i)"] + "-01").to_date
      @attendances = @user.attendances.where(worked_on: @first_day..@first_day.end_of_month, chg_status: "承認").order(:worked_on)
    end
  end
  
  private

    def user_params #StrongParametersなのでここに記述しないと更新が反映されない。
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :password_confirmation, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end
end
