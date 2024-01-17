module AttendancesHelper
  
  def attendance_state(attendance)
    if Date.current == attendance.worked_on # 受け取ったAttendanceｵﾌﾞｼﾞｪｸﾄが当日と一致する場合
      return '出社' if attendance.started_at.nil? # 出社が無ければ出社を返す
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil? # 出社が存在かつ退社が無ければ退社を返す
    end
    return false # # どれにも当てはまらなかった場合はfalseを返します。
  end

  def working_times(start, finish) # 出勤時間と退勤時間を受け取り、在社時間を計算して返します
    format("%02d:%02d", ((finish - start) / 3600).to_i, ((finish - start) % 3600 / 60).to_i)
  end

  def total_basic_work_time # ｵﾘｼﾞﾅﾙﾒｿｯﾄﾞ 基本時間と出勤日数の合計が〇:〇と表示するように定義
    basic_time_minutes = format_basic_info(@user.basic_work_time).split(':').map(&:to_i).reduce { |a, b| a * 60 + b }
    total_minutes = basic_time_minutes * @worked_sum
    formatted_hours = (total_minutes / 60).to_i
    formatted_minutes = (total_minutes % 60).to_i
    format("%02d:%02d", formatted_hours, formatted_minutes)
  end
end
