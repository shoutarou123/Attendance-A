class AddOvertimeReqToAttendances < ActiveRecord::Migration[7.1]
  def change
    add_column :attendances, :over_time_req, :date
    add_column :attendances, :chg_confirmed, :string
    add_column :attendances, :chg_status, :string
    add_column :attendances, :confirmed_request, :string
  end
end
