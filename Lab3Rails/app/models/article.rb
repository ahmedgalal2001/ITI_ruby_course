class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  # Active Storage association
  has_one_attached :image

  validates :title, presence: true
  validates :body, presence: true
end

  
  
  