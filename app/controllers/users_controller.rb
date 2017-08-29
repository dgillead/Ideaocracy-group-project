class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:suggestions, :ideas, :comments]
  
  def index
  end

  def suggestions
    if Suggestion.count <= 30
      @suggestions = Suggestion.where("user_id = ?", current_user.id).order("votes DESC")
    else
      @suggestions = Suggestion.where("user_id = ?", current_user.id).order("votes DESC").paginate(:page => params[:page])
    end
  end

  def ideas
    @ideas = current_user.ideas.paginate(:page => params[:page])
  end

  def comments
    if Comment.count <= 30
     @comments = Comment.where("user_id = ?", current_user.id)
    else
      @comments = Comment.where("user_id = ?", current_user.id).paginate(:page => params[:page])
    end 
  end

  def loves
    @ideas = Idea.where(id: current_user.loves)
    if @ideas.count >= 30
      @ideas = @ideas.paginate(:page => params[:page])
    end
  end
end
