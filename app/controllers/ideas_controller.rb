class IdeasController < HomeController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_idea, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_current_user, only: [:edit, :update, :destroy]

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
    if current_user
      @is_idea_creator = (current_user.id == @idea.user_id)
    end
    @suggestions = @idea.suggestions.all.order(votes: :desc)
    if current_user
      @user_id = current_user.id
    else
      @user_id = nil
    end
  end

  def edit
  end

  def update
    if @idea.update_attributes(idea_params)
      redirect_to @idea
    end
  end

  def destroy
    @idea.destroy
    redirect_to ideas_path
  end

  private

  def authenticate_current_user
    render '/errors/not_found' unless @idea.user_id == current_user.id
  end

  def idea_params
    params.require(:idea).permit(:title, :summary)
  end

  def find_idea
    @idea = Idea.find_by(id: params[:id])
  end

end
