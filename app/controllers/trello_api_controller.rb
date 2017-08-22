require 'trello'
class TrelloApiController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create_board]
  before_action :authenticate_user!

  def show
    Trello.configure do |trello|
      trello.developer_public_key = "cacfd2f5f9c6ae23474f2ebcd35d2dcc"
      trello.member_token = current_user.trello
    end

    @boards = Trello::Board.all
    @lists = @boards.first.lists
  end

  def create_board
    Trello.configure do |trello|
      trello.developer_public_key = "cacfd2f5f9c6ae23474f2ebcd35d2dcc"
      trello.member_token = current_user.trello
    end
    Trello::Board.create(name: params[:board])
  end

  def get_token
    current_user[:trello] = params[:token]
    current_user.save
    redirect_back(fallback_location: root_path)
  end
end
