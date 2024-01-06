class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception # CSRF対策
  include SessionsHelper # 親クラスの本controllerで定義することで全てのcontrollerでsessionshelperが使える
end
