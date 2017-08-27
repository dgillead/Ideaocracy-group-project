require 'trello'

class TrelloApiController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create_board]
  before_action :authenticate_user!
  before_action :find_idea, only: [:new]
  before_action :authenticate_current_user, only: [:new]

  def new
    if params[:collaborators]
      @collaborators_array = {}
      params[:collaborators].each do |collaborator|
        user = User.find(collaborator)
        username = user.username
        user_id = user.id
        @collaborators_array[:"#{username}"] = user_id
      end
    end
  end

  def create_board
    Trello.configure do |trello|
      trello.developer_public_key = ENV['trello_key']
      trello.member_token = current_user.trello
    end
    board = Trello::Board.create(name: params[:board])
    @url = board.url
    list_id = board.lists[0].id
    if params[:suggestions]
      params[:suggestions].each do |suggestion|
        Trello::Card.create(name: suggestion, list_id: list_id)
      end
    end
    if params[:collaborators]
      params[:collaborators].each do |collaborator|
        user = User.find(collaborator)
        HTTP.put("https://api.trello.com/1/boards/#{board.id}/members?email=#{user.email}&key=#{ENV['trello_key']}&token=#{board.client.member_token}")
      end
    end
    render :success
  end

  def get_token
    current_user[:trello] = params[:token]
    current_user.save
    redirect_back(fallback_location: root_path)
  end

  private

  def authenticate_current_user
    render '/errors/not_found' unless @idea.user_id == current_user.id
  end

  def find_idea
    @idea = Idea.find_by(id: params[:idea_id])
  rescue ActiveRecord::RecordNotFound
    render 'errors/not_found'
  end
end
