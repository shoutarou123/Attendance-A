class Attendance < ApplicationRecord
  belongs_to :user # 1対1

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
end
