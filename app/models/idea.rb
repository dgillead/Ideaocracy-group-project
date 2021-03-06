class Idea < ApplicationRecord
  belongs_to :user
  has_many :suggestions, dependent: :destroy

  validates :title, presence: true
  validates :summary, presence: true
  validates :user_id, presence: true
end
