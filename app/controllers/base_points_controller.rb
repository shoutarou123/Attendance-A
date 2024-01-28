class BasePointsController < ApplicationController
  
  def index
    @base_points = BasePoint.all
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
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @base_point = BasePoint.find(params[:id])
  end

  def update
    @base_point = BasePoint.find(params[:id])
    if @base_point.update(base_params)
      flash[:success] = "拠点情報を更新しました。"
      redirect_to base_points_url(@base_point)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @base_point = BasePoint.find(params[:id])
    @base_point.destroy
    flash[:success] = "#{@base_point.name}のデータを削除しました。"
    redirect_to base_points_url # 一覧へ遷移
  end

  private

    def base_params #StrongParametersなのでここに記述しないと更新が反映されない。
      params.require(:base_point).permit(:number, :name, :attendance_type)
    end

end
