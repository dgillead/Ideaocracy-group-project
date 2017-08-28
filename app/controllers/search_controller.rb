class SearchController < ApplicationController
  def search
    if params[:query].nil?
      @ideas = []
    else
      @ideas = Idea.search params[:query]
    end
  end
end
