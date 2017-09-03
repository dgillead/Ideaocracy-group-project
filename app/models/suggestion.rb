class Suggestion < ApplicationRecord
  belongs_to :idea
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :idea_id, presence: true
  validates :user_id, presence: true
  validates :body, presence: true
end
