class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info] # correct_userのbefore_actionで同じ@userが2回使用されてしまうため本ﾒｿｯﾄﾞを各ｱｸｼｮﾝに定義している
  before_action :logged_in_user, only: [:index, :show, :working, :edit, :update, :destroy, :edit_basic_info, :update_basic_info] # ﾛｸﾞｲﾝしていなければ一覧画面、出勤中一覧画面、編集画面、編集更新、削除、基本情報編集できない
  before_action :correct_user, only: [] # 現在ﾕｰｻﾞｰの情報のみ変更可。違うﾕｰｻﾞｰの変更不可。
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info] # 管理権限がないと削除、基本情報編集できない。
  before_action :set_one_month, only: :show # ﾍﾟｰｼﾞ出力前に1ヶ月分のﾃﾞｰﾀの存在を確認・ｾｯﾄ showｱｸｼｮﾝ実行前に発動

  def index
    # @users = User.paginate(page: params[:page]) # User.allから変更。paginateではｷｰが:pageで値がﾍﾟｰｼﾞ番号のﾊｯｼｭを引数にとります。User.paginateは:pageﾊﾟﾗﾒｰﾀに基づき、ﾃﾞｰﾀﾍﾞｰｽから一塊のﾃﾞｰﾀを取得する。ﾃﾞﾌｫﾙﾄは30件。
    @users = User.page(params[:page]).per(30) # kaminariでのpeginateに変更
  end

  def import
    if params[:file].present? && File.extname(params[:file].original_filename) == ".csv" # ﾌｧｲﾙが存在すること。かつｱｯﾌﾟﾛｰﾄﾞされたﾌｧｲﾙ名の拡張子が.csvである時
      flash[:success] = "CSVファイルを読み込みました。"
      User.import(params[:file])
      redirect_to users_url # ﾕｰｻﾞｰ一覧へ遷移
    else
      flash[:danger] = "CSVファイルを選択してください。"
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
    @user = User.find(params[:id])
    @worked_sum = @attendances.where.not(started_at: nil).count # 出社が何も無いじゃない数
    # @first_day = Date.current.beginning_of_month # 現在日付の月初
    # @last_day = @first_day.end_of_month # 上記の月の末日
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
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url # 一覧へ遷移
  end

  def edit_basic_info
  end

  def update_basic_info
  end

  private

    def user_params #StrongParametersなのでここに記述しないと更新が反映されない。
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :password_confirmation, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end
end
