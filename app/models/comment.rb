class Comment < ApplicationRecord
  belongs_to :suggestion
  belongs_to :user
end
