class AddBasicInfoToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :basic_work_time, :datetime, default: Time.current.change(hour: 8, min: 0, sec: 0)
    add_column :users, :designated_work_start_time, :datetime, default: Time.current.change(hour: 8, min: 18, sec: 0)
    add_column :users, :designated_work_end_time, :datetime, default: Time.current.change(hour: 17, min: 9, sec: 0)
  end
end
