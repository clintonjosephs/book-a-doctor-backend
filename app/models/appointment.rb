class Appointment < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :doctor, dependent: :destroy

  validates :date_of_appointment, presence: true
  validates :doctor_id, presence: true
  validates :user_id, presence: true
end
