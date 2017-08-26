class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :user_suggestions ]
  def index
  end

  def suggestions
    @suggestions = Suggestion.where("user_id = ?", current_user.id).order("votes DESC")
  end

  def ideas
    @ideas = current_user.ideas.paginate(:page => params[:page])
  end

  def comments
     @comments = Comment.where("user_id = ?", current_user.id)
  end

end
