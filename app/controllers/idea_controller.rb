class IdeaController < HomeController
  def new
    @idea = current_user.ideas.new
  end

  def index
    @ideas = Idea.all
  end
end
