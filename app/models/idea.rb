class Idea < ApplicationRecord
  belongs_to :user
  has_many :suggestions
  has_many :comments
end
