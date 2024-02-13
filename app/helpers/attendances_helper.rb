module AttendancesHelper
  
  def attendance_state(attendance)
    if Date.current == attendance.worked_on # 受け取ったAttendanceｵﾌﾞｼﾞｪｸﾄが当日と一致する場合
      return '出社' if attendance.started_at.nil? # 出社が無ければ出社を返す
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil? # 出社が存在かつ退社が無ければ退社を返す
    end
    return false # # どれにも当てはまらなかった場合はfalseを返します。
  end

  def working_times(start, finish) # 出勤時間と退勤時間を受け取り、在社時間を計算して返します
    hours_worked = (finish - start) / 3600.0 # 秒数を時間に変換
    format("%.2f", hours_worked)
  end
  
  def format_ended_at(day)
    day.ended_at.strftime('%H:%M') # 〇:〇表記に変換
  end
  
  def calculate_overtime_hours(formatted_ended_at, designated_work_end_time, approved)
    ended_at_hours, ended_at_minutes = formatted_ended_at.split(":").map(&:to_i) # フォーマットされた終了予定時間を時間と分に分割
    designated_work_end_hours, designated_work_end_minutes = designated_work_end_time.strftime('%H:%M').split(":").map(&:to_i) # 指定勤務終了時間を時間と分に分割
    overtime_seconds = (ended_at_hours * 3600 + ended_at_minutes * 60) - (designated_work_end_hours * 3600 + designated_work_end_minutes * 60)
    if approved == true  # :approved が '1' の場合、overtime_seconds に 24 時間分の秒数を足す
      overtime_seconds += 24 * 3600
    end
    overtime_hours = (overtime_seconds / 3600.0).round(2) # 秒数を時間に変換して少数第2位まで丸める
    format("%.2f", overtime_hours) # それをフォーマットで表示
  end
end
