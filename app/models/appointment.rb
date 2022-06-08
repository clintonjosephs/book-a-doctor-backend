class Appointment < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :doctor, dependent: :destroy

  # validations
  validates :date_of_appointment, presence: true
end
