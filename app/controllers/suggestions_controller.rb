class SuggestionsController < ApplicationController
  before_action :find_idea, only: [:create]
  def create
    @suggestion = @idea.suggestions.new(suggestion_params)
    @suggestion['user_id'] = current_user.id
    if @suggestion.save
      redirect_to @idea
    end
  end


  private
  def suggestion_params
    params.permit(:body)
  end

  def find_idea
    @idea = Idea.find_by(id: params[:idea_id])
  end
end