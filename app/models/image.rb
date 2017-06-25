class Image < ApplicationRecord
  belongs_to :album
  belongs_to :user

  has_many :activities, as: :trackable, dependent: :destroy

  mount_uploader :url, ImageUploader

  scope :newest, ->{order created_at: :desc}
  mount_uploader :url, ImageUploader
end
