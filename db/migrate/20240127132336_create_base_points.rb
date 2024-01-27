class CreateBasePoints < ActiveRecord::Migration[7.1]
  def change
    create_table :base_points do |t|
      t.string :number
      t.string :name
      t.string :attendance_type

      t.timestamps
    end
  end
end
