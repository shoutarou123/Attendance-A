class User < ApplicationRecord
  has_many :attendances, dependent: :destroy # 1対多 多数のため複数形 userが親 attendancesが子
                                             # userが削除されたら紐づけられたattendanceも一緒に削除される
  attr_accessor :remember_token # remember_tokenという仮想の属性を作成する。
  before_save { self.email = email.downcase } # email小文字化
  
  validates :name,  presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # 正規表現
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX }, # 正規表現をformatにしている
                    uniqueness: true # 一意性検証しかしﾃﾞｰﾀﾍﾞｰｽﾚﾍﾞﾙではない
  has_secure_password # 1. ﾊｯｼｭ化したﾊﾟｽﾜｰﾄﾞを、ﾃﾞｰﾀﾍﾞｰｽのpassword_digestというｶﾗﾑに保存できるようになる。
                      # 2. ﾍﾟｱとなる仮想的なｶﾗﾑであるpasswordとpassword_confirmationが使えるようになる。さらに存在性と値が一致するかどうかの検証も追加される。
                      # 3. authenticateﾒｿｯﾄﾞが使用可能となる。このﾒｿｯﾄﾞは引数の文字列がﾊﾟｽﾜｰﾄﾞと一致した場合ｵﾌﾞｼﾞｪｸﾄを返し、ﾊﾟｽﾜｰﾄﾞが一致しない場合はfalseを返す。
  validates :affiliation, length: { in: 2..30 }, allow_blank: true # 空でもﾊﾞﾘﾃﾞｰｼｮﾝ通過
  validates :basic_work_time, presence: true
  validates :designated_work_start_time, presence: true
  validates :designated_work_end_time, presence: true
  validates :password, presence: true, length: { minimum: 6}, allow_nil: true # allow_nil: true空でもﾊﾞﾘﾃﾞｰｼｮﾝ素通り。新規登録時はhas_secure_passwordが存在性を検証する。

  # 渡された文字列のハッシュ値を返します。
  def User.digest(string) # User.digestは、文字列を暗号化して安全な形式で保存するためにBCryptを使用
    cost = # このﾒｿｯﾄﾞは引数として与えられた文字列をﾊｯｼｭ化し、安全な形式で保存するためのBCryptの機能を使っている。
      if ActiveModel::SecurePassword.min_cost # min_costがtrueであれば
        BCrypt::Engine::MIN_COST # BCryptのｺｽﾄを最小化
      else
        BCrypt::Engine.cost # BCryptのｺｽﾄは標準
      end
    BCrypt::Password.create(string, cost: cost) # 与えられた文字列をBCryptを用いてﾊｯｼｭ化し、安全な形式で返す。costｵﾌﾟｼｮﾝは、ﾊｯｼｭ化する際の計算ｺｽﾄを指定する。そのｺｽﾄは、min_costがtrueの場合はBCryptの最小ｺｽﾄ、それ以外の場合は標準のｺｽﾄに設定される。
  end

  def User.new_token # ﾗﾝﾀﾞﾑなﾄｰｸﾝを返します。
    SecureRandom.urlsafe_base64
  end

  # 永続ｾｯｼｮﾝのためﾊｯｼｭ化したﾄｰｸﾝをﾃﾞｰﾀﾍﾞｰｽに記憶します。
  def remember
    self.remember_token = User.new_token # Userｸﾗｽのnew_tokenﾒｿｯﾄﾞを呼び出して新しいﾄｰｸﾝを生成し、そのﾄｰｸﾝをremember_token属性に代入。
    update_attribute(:remember_digest, User.digest(remember_token)) # User.digestﾒｿｯﾄﾞを使ってremember_tokenをﾊｯｼｭ化し、その結果をremember_digest属性に保存。update_attributeは、ﾃﾞｰﾀﾍﾞｰｽのﾚｺｰﾄﾞを更新するためのActive Recordﾒｿｯﾄﾞの1つです。
  end # update_attributesと違いsを付けないことでﾊﾞﾘﾃﾞｰｼｮﾝ素通りさせている

 
  def authenticated?(remember_token) # ﾄｰｸﾝがﾀﾞｲｼﾞｪｽﾄと一致すればtrueを返します。
    return false if remember_digest.nil? # ﾀﾞｲｼﾞｪｽﾄが存在しない場合はfalseを返して終了。
    BCrypt::Password.new(remember_digest).is_password?(remember_token) # ﾄｰｸﾝとﾀﾞｲｼﾞｪｽﾄが一致すればtrue。
  end

  def forget # ﾕｰｻﾞｰのﾛｸﾞｲﾝ情報を破棄します。
    update_attribute(:remember_digest, nil) # attribute(属性)
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: 'Shift_JIS:UTF-8') do |row| # CSV.foreach CSVﾌｧｲﾙを一行ずつ処理するﾒｿｯﾄﾞ fileはﾌｧｲﾙｵﾌﾞｼﾞｪｸﾄ,pathでそのﾊﾟｽを取得 CSVﾌｧｲﾙの最初の行がﾍｯﾀﾞｰ情報を含んでいるか指定。trueの場合ﾍｯﾀﾞｰ行は処理対象から除外。ｴﾝｺｰﾃﾞｨﾝｸﾞをUTF-8に変換。
      next if row["email"].nil? # emailカラムがNULLの場合はスキップする
      user = find_by(name: row["name"]) || new # 名前が見つかればﾚｺｰﾄﾞを呼び出し見つかれなければ新しく作成
      user.attributes = row.to_hash.slice(*updatable_attributes) # CSVからデータを取得し、設定する
      user.save
    end
  end

  def self.updatable_attributes # 更新を許可するｶﾗﾑを定義
    ["name", "email", "affiliation", "employee_number", "uid", "password", "password_confirmation", "basic_work_time", "designated_work_start_time", "designated_work_end_time", "superior", "admin"]
  end
  
  def self.generate_csv(attendances)
    CSV.generate(headers: true) do |csv|
      csv << ['日付', '曜日', '出社', '退社', '備考']  
       attendances.each do |attendance|

        csv << [
          attendance.worked_on.strftime('%m/%d'),  # 日付を指定のフォーマットに変換
          attendance.worked_on.strftime('%a'),    # 曜日を取得
          (attendance.chg_status == '申請中' ? '' : attendance.started_at&.strftime('%H:%M')),  # 出社時間を取得または'申請中'
          (attendance.chg_status == '申請中' ? '' : attendance.finished_at&.strftime('%H:%M')), # 退社時間を取得または'申請中'
          attendance.note
        ]
      end
    end
  end
end