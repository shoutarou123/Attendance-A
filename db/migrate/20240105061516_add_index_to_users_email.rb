class AddIndexToUsersEmail < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :email, unique: true # ﾃﾞｰﾀﾍﾞｰｽに一意性をもたせる
  end
end
