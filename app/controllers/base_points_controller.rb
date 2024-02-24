class BasePointsController < ApplicationController
  before_action :set_base_point, only: [:edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :admin_user, only: [:index, :new, :create, :edit, :update, :destroy]
  
  def index
    @base_points = BasePoint.all
  end

  def show
  end

  def new
    @base_point = BasePoint.new
  end

  def create
    @base_point = BasePoint.new(base_params)
    if @base_point.save # 保存成功
      flash[:success] = '拠点新規作成に成功しました。'
      redirect_to base_points_url # 一覧へ遷移
    else
      flash[:danger] = "拠点の新規作成に失敗しました。"
      render 'index'
    end
  end

  def edit
  end

  def update
      if @base_point.update(base_params)
        flash[:success] = "拠点情報を更新しました。"
        redirect_to base_points_url
      else
        flash[:danger] = "拠点の更新に失敗しました。"
        redirect_to edit_base_point_path
      end
  end

  def destroy
    if @base_point.destroy
      flash[:success] = "#{@base_point.name}のデータを削除しました。"
    else
      flash[:danger] = "拠点の削除に失敗しました。"
    end
    redirect_to base_points_url
  end

  private
    
    def set_base_point
      @base_point = BasePoint.find(params[:id])
    end

    def base_params #StrongParametersなのでここに記述しないと更新が反映されない。
      params.require(:base_point).permit(:number, :name, :attendance_type)
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    def admin_user
      redirect_to root_url unless logged_in? && current_user.admin?
    end

end
