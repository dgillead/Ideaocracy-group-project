class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_user!
  before_action :find_suggestion, only: [:create, :update]
  before_action :find_idea, only: [:create]
  before_action :find_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_current_user, only: [:edit, :update, :destroy]

  def create
    @comment = @suggestion.comments.new(comment_params)
    @comment[:user_id] = current_user.id
    if @comment.save
      redirect_to idea_path(@idea, anchor: "#{@suggestion.id}")
    end
  end

  def update
    if @comment.update_attributes(update_comment_params)
      redirect_to idea_path(@comment.suggestion.idea.id, anchor: "#{@comment.suggestion.id}")
    end
  end

  def destroy
    @comment.destroy
    redirect_to idea_path(@comment.suggestion.idea.id)
  end

  private

  def authenticate_current_user
    render '/errors/not_found' unless @comment.user_id == current_user.id
  end

  def find_idea
    @idea = Idea.find_by(id: params[:idea_id])
  end

  def find_comment
    @comment = Comment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render 'errors/not_found'
  end

  def find_suggestion
    @suggestion = Suggestion.find_by(id: params[:suggestion_id])
  end

  def update_comment_params
    params.require(:comment).permit(:body)
  end

  def comment_params
    params.permit(:body)
  end
end
