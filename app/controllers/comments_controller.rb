class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_user!
  before_action :find_suggestion, only: [:create]
  before_action :find_idea, only: [:create]
  before_action :find_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @suggestion.comments.new(comment_params)
    @comment[:user_id] = current_user.id
    if @comment.save
      redirect_to @idea
    end
  end

  def edit
  end

  def update
    if @comment.update_attributes(body: params[:comment][:body])
      redirect_to idea_path(@comment.suggestion.idea.id)
    end
  end

  def destroy
    @comment.destroy
    redirect_to idea_path(@comment.suggestion.idea.id)
  end

  private 

  def find_idea
    @idea = Idea.find_by(id: params[:idea_id])
  end

  def find_comment
    @comment = Comment.find_by(id: params[:id])
  end

  def find_suggestion
    @suggestion = Suggestion.find_by(id: params[:suggestion_id])
  end

  def comment_params
    params.permit(:body)
  end
end