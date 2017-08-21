class Suggestion < ApplicationRecord
  belongs_to :idea
  belongs_to :user
  has_many :comments
end
