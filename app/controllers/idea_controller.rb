class IdeaController < HomeController
  def new
    @idea = current_user.ideas.new
  end
end
