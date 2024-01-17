module UsersHelper

  # 勤怠基本情報を指定のﾌｫｰﾏｯﾄで返します。  
  def format_basic_info(time) # 基本時間、指定勤務開始時間、指定勤務終了時間のﾌｫｰﾏｯﾄ時間の指定(basic_infoとなっているから)
    time_in_minutes = time.hour * 60 + time.min
    "%02d:%02d" % [time_in_minutes / 60, time_in_minutes % 60]
    # format("%02d:%02d", time_in_minutes / 60, time_in_minutes % 60)
    # format("%02d:%02d", time.hour * 60 + time.min)
    # format("%02d:%02d", time.hour, time.min) # 表記 format("%.2f", ((time.hour * 60) + time.min) / 60.0) から変更
  end
end
# %は数値によって変化し、.2fは値がない場合は.00、値がある場合はそのまま、小数点第三位以上まである場合は第二位まで表示しそれ以降は切り捨てます
# 7時30分の場合 ((7 * 60) + 30) / 60.0 = 7.5
# 最後の60.0にも意味があって、例えばこれを60としてしまうと整数同士の計算と判断されてしまい上記の計算結果が7となってしまいます。その場合7.00と表示されてしまうためこのような記述となっています。