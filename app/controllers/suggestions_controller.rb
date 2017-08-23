class SuggestionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_user!
  before_action :find_idea, only: [:create]
  before_action :find_suggestion, only: [:up_vote, :down_vote]
  before_action :find_suggestion_id, only: [:update]
  before_action :authenticate_current_user, only: [:update, :destroy]

  def create
    @suggestion = @idea.suggestions.new(suggestion_params)
    @suggestion[:user_id] = current_user.id
    if @suggestion.save
      redirect_to @idea
    end
  end

  def update
    if @suggestion.update_attributes(update_suggestion_params)
      redirect_to idea_path(@suggestion.idea.id)
    end
  end

  def destroy
    @suggestion = Suggestion.find_by(id: params[:id])
    @idea = @suggestion.idea
    @suggestion.destroy
    redirect_to @idea
  end

  def up_vote
    if @suggestion.up_votes.include?(current_user.id)
      new_votes = @suggestion.votes
    else
      new_votes = @suggestion.votes + 1
      @suggestion.down_votes.delete(current_user.id)
      @suggestion.up_votes.push(current_user.id)
    end
    @suggestion.update_attributes(votes: new_votes)
    redirect_back(fallback_location: root_path)
  end

  def down_vote
    if @suggestion.down_votes.include?(current_user.id)
      new_votes = @suggestion.votes
    else
      new_votes = @suggestion.votes - 1
      @suggestion.up_votes.delete(current_user.id)
      @suggestion.down_votes.push(current_user.id)
    end
    @suggestion.update_attributes(votes: new_votes)
    redirect_back(fallback_location: root_path)
  end

  private

  def update_suggestion_params
    params.require(:suggestion).permit(:body)
  end

  def find_suggestion_id
    @suggestion = Suggestion.find_by(id: params[:id])
  end

  def authenticate_current_user
    render '/errors/not_found' unless @suggestion.user_id == current_user.id
  end

  def suggestion_params
    params.permit(:body)
  end

  def find_suggestion
    @suggestion = Suggestion.find_by(id: params[:suggestion_id])
  end

  def find_idea
    @idea = Idea.find_by(id: params[:idea_id])
  end
end
