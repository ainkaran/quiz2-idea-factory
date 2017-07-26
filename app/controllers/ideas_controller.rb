class IdeasController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

  before_action :find_idea, only: [:edit, :destroy, :show, :update]

  before_action :authorize_user!, only: [:edit, :destroy, :update]

  def index
    @ideas = Idea.order(created_at: :desc)
  end

  def new
    @idea = Idea.new
  end

  def edit

  end

  def update
    if @idea.update idea_params
      redirect_to idea_path(@idea)
    else
      render :edit
    end
  end

  def destroy
    @idea.destroy
    redirect_to ideas_path
  end

  def show
    # @idea = Idea.find params[:id]
    @review = Review.new
    @like = @idea.likes.find_by(user: current_user)
    # Using association methods just builds queries, meaning that
    # we can continue chaining more and more query methods such order, limit, offset, where
    # , etc
    @reviews = @idea.reviews.order(created_at: :desc)
  end

  def create
    @idea = Idea.new idea_params
    @idea.user = current_user

    if @idea.save
      redirect_to idea_path(@idea)
    else
      render :new
    end
  end

  private

  def idea_params
    params.require(:idea).permit(:title, :description)
  end

  def find_idea
    @idea = Idea.find params[:id]
  end

  def authorize_user!
    unless can?(:manage, @idea)
      head :unauthorized
    end
  end

end
