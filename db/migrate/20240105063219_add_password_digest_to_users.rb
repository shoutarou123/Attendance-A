class AddPasswordDigestToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :password_digest, :string # has_secure_passwordの機能を利用するためdigestが必要
  end
end
