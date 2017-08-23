require 'trello'
class TrelloApiController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create_board]
  before_action :authenticate_user!
  before_action :find_idea, only: [:new]

  def new
    @collaborators_array = {}
    params[:collaborators].each do |collaborator|
      user = User.find(collaborator)
      username = user.username
      user_id = user.id
      @collaborators_array[:"#{username}"] = user_id
    end
    binding.pry
  end

  def create_board
    Trello.configure do |trello|
      trello.developer_public_key = Rails.application.secrets.trello_api_key
      trello.member_token = current_user.trello
    end
    board = Trello::Board.create(name: params[:board])
    @url = board.url
    list_id = board.lists[0].id
    params[:suggestions].each do |suggestion|
      Trello::Card.create(name: suggestion, list_id: list_id)
    end
    render :success
  end

  def get_token
    current_user[:trello] = params[:token]
    current_user.save
    redirect_back(fallback_location: root_path)
  end

  private

  def find_idea
    @idea = Idea.find_by(id: params[:idea_id])
  rescue ActiveRecord::RecordNotFound
    render 'errors/not_found'
  end
end
