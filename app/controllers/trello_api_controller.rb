require 'trello'
class TrelloApiController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create_board]
  def show

    Trello.configure do |trello|
      trello.developer_public_key = "cacfd2f5f9c6ae23474f2ebcd35d2dcc"
      trello.member_token = "e80136503b6ff1cc5ce1994a9dfed56d47ecb75a7bb92a20f189aece99fffdf0"
    end

    @boards = Trello::Board.all
    @lists = @boards.first.lists
  end

  def create_board
    Trello.configure do |trello|
      trello.developer_public_key = "cacfd2f5f9c6ae23474f2ebcd35d2dcc"
      trello.member_token = "e80136503b6ff1cc5ce1994a9dfed56d47ecb75a7bb92a20f189aece99fffdf0"
    end
    Trello::Board.create(name: params[:board])
  end
end