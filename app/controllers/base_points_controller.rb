class BasePointsController < ApplicationController
  
  def index
    @base_points = BasePoint.all
  end

  def new
    @base_point = BasePoint.new
  end
end
