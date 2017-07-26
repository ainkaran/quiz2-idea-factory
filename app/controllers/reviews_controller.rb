class ReviewsController < ApplicationController

  # render json: params
  
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def create
    @idea = Idea.find(params[:idea_id])
    # @review = Review.new(review_params)
    @review = @idea.reviews.build(review_params)
    # @review.idea = @idea
    @review.user = @current_user

    if cannot? :create, @review
      flash[:alert] = "Access Denied. You cannot create a review for your own idea!"
      redirect_to @idea
    elsif @review.save
      redirect_to @idea, notice: 'Review Successfully Created!'
    else
      flash[:alert] = 'Review not created'
      render '/ideas/show'
    end
  end

  def destroy
    @review = Review.find(params[:id])

    if can?(:destroy, @review)
      @review.destroy
      redirect_to idea_path(params[:idea_id]), notice: 'Review Deleted!'
    else
      redirect_to idea_path(params[:idea_id]), alert: 'Review NOT Deleted!'
      # head :unauthorized
    end
  end

  def edit
    @review  = Review.find(params[:id])
    @idea = Idea.find(params[:idea_id])

    unless can? :edit, @review
      flash[:alert] = "Access Denied. You cannot edit a review that is not yours"
      redirect_to root_path
    end
  end

  def update
    @review  = Review.find(params[:id])
    @idea = Idea.find(params[:idea_id])

    if cannot? :edit, @review
      flash[:alert] = "Access Denied. You cannot edit a idea that is not yours"
      redirect_to @idea
    elsif @review.update(review_params)
      flash[:notice] = 'Review successfully updated.'
      redirect_to idea_path(@idea)
    else
      flash.now[:alert] = 'Error updating review'
      render '/ideas/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:body)
  end

end
