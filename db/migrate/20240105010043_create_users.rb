class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.boolean :superior, default: false # ﾃﾞﾌｫﾙﾄで上長権限持たないようにしている

      t.timestamps
    end
  end
end
