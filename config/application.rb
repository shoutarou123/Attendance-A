require_relative "boot"

require 'csv' # CSVﾗｲﾌﾞﾗﾘ追加
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AttendanceAApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1
    config.time_zone = 'Asia/Tokyo' # 日時アジア時間
    config.i18n.default_locale = :ja # デフォルトの言語を日本語に設定します。
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    # ｶﾗﾑ名などを日本語化するため、設定が記述されたﾛｹｰﾙﾌｧｲﾙを作成するにあたり、それらのﾌｧｲﾙの内容がｱﾌﾟﾘｹｰｼｮﾝに正しく読み込まれるよう設定したもの。
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
