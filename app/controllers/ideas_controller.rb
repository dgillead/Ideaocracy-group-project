class IdeasController < HomeController
  def new
    @idea = Idea.new
  end

  def index
    @ideas = Idea.all
  end
end
