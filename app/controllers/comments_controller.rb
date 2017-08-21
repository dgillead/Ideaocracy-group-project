class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_user!
  before_action :find_suggestion, only: [:create]
  before_action :find_idea, only: [:create]

  def create
    @comment = @suggestion.comments.new(comment_params)
    @comment[:user_id] = current_user.id
    if @comment.save
      redirect_to @idea
    end
  end

  private 

  def find_idea
    @idea = Idea.find_by(id: params[:idea_id])
  end

  def find_suggestion
    @suggestion = Suggestion.find_by(id: params[:suggestion_id])
  end

  def comment_params
    params.permit(:body)
  end
end