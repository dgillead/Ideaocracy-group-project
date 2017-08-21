class SuggestionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_user!
  before_action :find_idea, only: [:create]
  before_action :find_suggestion, only: [:up_vote, :down_vote]

  def create
    @suggestion = @idea.suggestions.new(suggestion_params)
    @suggestion[:user_id] = current_user.id
    if @suggestion.save
      redirect_to @idea
    end
  end

  def up_vote
    new_votes = @suggestion.votes + 1
    @suggestion.update_attributes(votes: new_votes)
  end

  private

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
