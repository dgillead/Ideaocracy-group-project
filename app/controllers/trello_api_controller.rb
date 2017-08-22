require 'trello'
class TrelloApiController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create_board]
  before_action :authenticate_user!
  before_action :find_idea, only: [:new]

  def new
  end

  def create_board
    Trello.configure do |trello|
      trello.developer_public_key = "cacfd2f5f9c6ae23474f2ebcd35d2dcc"
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
  end
end
