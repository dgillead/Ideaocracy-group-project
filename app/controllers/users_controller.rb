class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :user_suggestions ]
  def index
  end

  def suggestions
    @suggestions = current_user.suggestions.all.order("votes DESC")
  end

  def ideas
     @ideas = current_user.ideas.all
  end

  def comments
     @comments = current_user.comments.all
  end

end
