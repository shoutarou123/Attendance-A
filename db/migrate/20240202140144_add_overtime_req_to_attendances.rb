class AddOvertimeReqToAttendances < ActiveRecord::Migration[7.1]
  def change
    add_column :attendances, :over_time_req, :date
    add_column :attendances, :chg_confirmed, :string
    add_column :attendances, :chg_status, :string
    add_column :attendances, :confirmed_request, :string
    add_column :attendances, :task_description, :string
    add_column :attendances, :approved, :boolean
    add_column :attendances, :ended_at, :datetime
    add_column :attendances, :overwork_chk, :boolean
    add_column :attendances, :overwork_status, :string
    add_column :attendances, :overtime_instructor, :string
    add_column :attendances, :aprv_confirmed, :string
    add_column :attendances, :aprv_chk, :boolean
    add_column :attendances, :aprv_status, :string
    add_column :attendances, :chg_next_day, :boolean
    add_column :attendances, :b4_started_at, :datetime
    add_column :attendances, :b4_finished_at, :datetime
  end
end
