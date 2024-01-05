class User < ApplicationRecord
  before_save { self.email = email.downcase } # email小文字化

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # 正規表現
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX }, # 正規表現をformatにしている
                    uniqueness: true # 一意性検証しかしﾃﾞｰﾀﾍﾞｰｽﾚﾍﾞﾙではない
  has_secure_password # 1. ﾊｯｼｭ化したﾊﾟｽﾜｰﾄﾞを、ﾃﾞｰﾀﾍﾞｰｽのpassword_digestというｶﾗﾑに保存できるようになる。
                      # 2. ﾍﾟｱとなる仮想的なｶﾗﾑであるpasswordとpassword_confirmationが使えるようになる。さらに存在性と値が一致するかどうかの検証も追加される。
                      # 3. authenticateﾒｿｯﾄﾞが使用可能となる。このﾒｿｯﾄﾞは引数の文字列がﾊﾟｽﾜｰﾄﾞと一致した場合ｵﾌﾞｼﾞｪｸﾄを返し、ﾊﾟｽﾜｰﾄﾞが一致しない場合はfalseを返す。
  validates :password, presence: true, length: { minimum: 6}
end