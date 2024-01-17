class Attendance < ApplicationRecord
  belongs_to :user # 1対1

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }

  validate :finished_at_is_invalid_without_a_started_at # 出勤時間が存在しない場合、退勤時間は無効

  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present? # 出勤空かつ退勤存在の時、ｴﾗｰ表示追加
  end
end
