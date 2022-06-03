class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # relationships
  has_one_attached :image, dependent: :destroy
  has_many :appointments, dependent: :destroy

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end
end
