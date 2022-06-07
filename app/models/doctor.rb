class Doctor < ApplicationRecord
  # relationships
  has_one_attached :image, dependent: :destroy
  has_many :appointments, dependent: :destroy

  # validations
  validates :name, presence: true
  validates :specialization, presence: true
  validates :city, presence: true
  validates :description, presence: true
  validates :cost_per_day, presence: true

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end
end
