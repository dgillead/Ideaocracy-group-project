class Comment < ApplicationRecord
  belongs_to :suggestion
  belongs_to :user

  validates :suggestion_id, presence: true
  validates :body, presence: true
end
