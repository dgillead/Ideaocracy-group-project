class IdeasController < HomeController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_idea, only: [:show, :edit, :update, :destroy, :new_collaborator, :love_idea]
  before_action :authenticate_current_user, only: [:edit, :update, :destroy]

  def new
    @idea = Idea.new
  end

  def index
    # @ideas = Idea.all.order(created_at: :desc)
    @ideas = Idea.paginate(:page => params[:page])
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

  def love_idea
    if !@idea.loves.include?(current_user.id)
      @idea.loves.push(current_user.id)
    else
      @idea.loves.delete(current_user.id)
    end
    @idea.save
  end

  def new_collaborator
    if @idea.collaborators.include?(current_user.id)
      flash[:error] = "You\'ve already indicated you would like to collaborate on this idea."
    else
      flash[:success] = "Added to collaborators list."
      @idea.collaborators.push(current_user.id)
      @idea.save
    end
    redirect_to @idea
  end

  private

  def authenticate_current_user
    render '/errors/not_found' unless @idea.user_id == current_user.id
  end

  def idea_params
    params.require(:idea).permit(:title, :summary)
  end

  def find_idea
    @idea = Idea.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render 'errors/not_found'
  end
end
