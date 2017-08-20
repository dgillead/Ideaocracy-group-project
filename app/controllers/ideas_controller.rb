class IdeasController < HomeController
  def new
    @idea = Idea.new
  end
end
