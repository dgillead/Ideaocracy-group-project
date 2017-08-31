class IdeasController < HomeController
  before_action :authenticate_user!, except: [:index, :show, :new_collaborator, :delete_collaborator]
  before_action :find_idea, only: [:show, :edit, :update, :destroy, :new_collaborator, :love_idea, :delete_collaborator]
  before_action :authenticate_current_user, only: [:edit, :update, :destroy]

  def new
    @idea = Idea.new
  end

  def index
    if params[:sort] == 'date'
      @ideas = Idea.all.order(created_at: :desc).paginate(:page => params[:page])
    else
      @ideas = Idea.all.order(loves_count: :desc).paginate(:page => params[:page])
    end
  end

  def create
    @idea = current_user.ideas.new(idea_params)
    if @idea['tags']
      @idea['tags'] = @idea['tags'].downcase
    end
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
      current_user.loves.push(@idea.id)
    @idea.save
    current_user.save
      @idea.update_attributes(loves_count: @idea.loves_count + 1)
    else
      @idea.loves.delete(current_user.id)
      current_user.loves.delete(@idea.id)
    @idea.save
    current_user.save
      @idea.update_attributes(loves_count: @idea.loves_count - 1)
    end
  end

  def new_collaborator
    if current_user
      if @idea.collaborators.include?(current_user.id)
        flash[:error] = "You\'ve already indicated you would like to collaborate on this idea."
      else
        flash[:success] = "Added to collaborators list."
        @idea.collaborators.push(current_user.id)
        @idea.save
      end
    else
      flash[:error] = "You\'re not signed in, please sign in first"
    end
    redirect_to @idea
  end

  def delete_collaborator
    if current_user
      if !@idea.collaborators.include?(current_user.id)
        flash[:error] = "You\'re not on the list"
      else
        flash[:success] = "Removed from collaborators list"
        @idea.collaborators.delete(current_user.id)
        @idea.save
      end
    else
      flash[:error] = "You\'re not sign in, please sign in first"
    end
      redirect_to @idea
  end

  def search_tags
    @ideas = Idea.where("tags like ?", "%#{params[:q].downcase}%")
  end

  private

  def authenticate_current_user
    render '/errors/not_found' unless @idea.user_id == current_user.id
  end

  def idea_params
    params.require(:idea).permit(:title, :summary, :tags)
  end

  def find_idea
    @idea = Idea.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render 'errors/not_found'
  end
end
