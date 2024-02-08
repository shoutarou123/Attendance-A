module AttendancesHelper
  
  def attendance_state(attendance)
    if Date.current == attendance.worked_on # 受け取ったAttendanceｵﾌﾞｼﾞｪｸﾄが当日と一致する場合
      return '出社' if attendance.started_at.nil? # 出社が無ければ出社を返す
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil? # 出社が存在かつ退社が無ければ退社を返す
    end
    return false # # どれにも当てはまらなかった場合はfalseを返します。
  end

  def working_times(start, finish) # 出勤時間と退勤時間を受け取り、在社時間を計算して返します
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  
  def format_ended_at(day)
    day.ended_at.strftime("%H：%M") # 〇:〇表記に変換
  end
end
