class CreateAttendances < ActiveRecord::Migration[7.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.string :note
      t.references :user, null: false, foreign_key: true # NULL値、つまり空欄を許可しないという指定。foreign_key: true 外部ｷｰ　指定したｶﾗﾑの自由な記述を許可せず、指定したｶﾗﾑの値のみしか使えないようにする制限のこと

      t.timestamps
    end
  end
end
