class IdeasController < HomeController
  before_action :find_idea, only: [:show]

  def new
    @idea = Idea.new
  end

  def index
    @ideas = Idea.all
  end

  def create
    @idea = current_user.ideas.new(idea_params)
    if @idea.save
      redirect_to @idea
    else
      render :new
    end
  end

  def show
  end

  private

  def idea_params
    params.require(:idea).permit(:title, :summary)
  end

  def find_idea
    @idea = Idea.find_by(id: params[:id])
  end
end
