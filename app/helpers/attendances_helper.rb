module AttendancesHelper
  
  def attendance_state(attendance)
    if Date.current == attendance.worked_on # 受け取ったAttendanceｵﾌﾞｼﾞｪｸﾄが当日と一致する場合
      return '出社' if attendance.started_at.nil? # 出社が無ければ出社を返す
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil? # 出社が存在かつ退社が無ければ退社を返す
    end

    false
  end
end
