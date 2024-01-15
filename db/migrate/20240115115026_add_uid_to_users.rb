class AddUidToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :uid, :integer
  end
end
