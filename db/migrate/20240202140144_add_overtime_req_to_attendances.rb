class AddOvertimeReqToAttendances < ActiveRecord::Migration[7.1]
  def change
    add_column :attendances, :over_time_req, :date
  end
end
