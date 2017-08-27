require 'elasticsearch/model'
class Idea < ApplicationRecord
  belongs_to :user
  has_many :suggestions

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
end
  Idea.import