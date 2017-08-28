require 'elasticsearch/model'
class Idea < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :user
  has_many :suggestions
end
Idea.import force: true