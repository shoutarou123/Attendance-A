class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info] # correct_userのbefore_actionで同じ@userが2回使用されてしまうため本ﾒｿｯﾄﾞを各ｱｸｼｮﾝに定義している
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info] # ﾛｸﾞｲﾝしていなければ一覧画面、編集画面、編集更新、削除、基本情報編集できない
  before_action :correct_user, only: [:edit, :update] # 現在ﾕｰｻﾞｰの情報のみ変更可。違うﾕｰｻﾞｰの変更不可。
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info] # 管理権限がないと削除、基本情報編集できない。
  before_action :set_one_month, only: :show # ﾍﾟｰｼﾞ出力前に1ヶ月分のﾃﾞｰﾀの存在を確認・ｾｯﾄ showｱｸｼｮﾝ実行前に発動

  def index
    # @users = User.paginate(page: params[:page]) # User.allから変更。paginateではｷｰが:pageで値がﾍﾟｰｼﾞ番号のﾊｯｼｭを引数にとります。User.paginateは:pageﾊﾟﾗﾒｰﾀに基づき、ﾃﾞｰﾀﾍﾞｰｽから一塊のﾃﾞｰﾀを取得する。ﾃﾞﾌｫﾙﾄは30件。
    @users = User.page(params[:page]).per(30) # kaminariでのpeginateに変更
  end

  def show
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
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation)
    end

    # beforeフィルター

    def set_user # paramsﾊｯｼｭからﾕｰｻﾞｰを取得。使いまわすため記述したもの。
      @user = User.find(params[:id])
    end

    def logged_in_user # ﾛｸﾞｲﾝ済のﾕｰｻﾞｰか確認します
      unless logged_in? # ﾛｸﾞｲﾝしていなければ
        store_location # urlの記憶。sessions_helper参照
        flash[:danger] = "ログインしてください。"
        redirect_to login_url # ﾛｸﾞｲﾝ画面遷移
      end
    end

    def correct_user # ｱｸｾｽしたﾕｰｻﾞｰが現在ﾛｸﾞｲﾝしているﾕｰｻﾞｰか確認します
      # @user = User.find(params[:id])の記述が不要になる理由は上記のset_userで定義しており、引数に@userを指定しているため。
      redirect_to(root_url) unless current_user?(@user) # ﾕｰｻﾞｰが現在ﾕｰｻﾞｰと一致しなければ、ﾄｯﾌﾟﾍﾟｰｼﾞに遷移。ｾｯｼｮﾝﾍﾙﾊﾟｰのﾒｿｯﾄﾞを使用。
    end

    def admin_user # ｼｽﾃﾑ管理権限所有かどうか判定します。
      redirect_to(root_url) unless current_user.admin? # 管理権限がなければﾄｯﾌﾟﾍﾟｰｼﾞに遷移
    end
  end
