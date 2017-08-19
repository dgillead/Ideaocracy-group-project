class User < ApplicationRecord
  has_many :ideas
  has_many :suggestions, through: :ideas
  has_many :comments, through: :ideas
  has_many :comments, through: :suggestions
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
