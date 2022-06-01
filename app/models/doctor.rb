class Doctor < ApplicationRecord

  # relationships
  has_one_attached :image, dependent: :destroy
  has_many :appointments, dependent: :destroy
end
