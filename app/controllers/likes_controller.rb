class LikesController < ApplicationController
  # render jason: params
  before_action :authenticate_user!
  before_action :find_idea, only: [:create]
  before_action :find_like, only: [:destroy]

  def create
    like = Like.new user: current_user, idea: @idea
    if cannot? :like, @idea
      redirect_to @idea, alert: 'Cannot like your own idea, dummy!'
    elsif like.save
      redirect_to @idea, notice: 'Thanks for liking! 😁'
    else
      redirect_to @idea, alert: like.errors.full_messages.join(', ')
    end
  end

  def destroy
    if @like.destroy
      redirect_to @like.idea, notice: '😂'
    else
      redirect_to @like.idea, alert: @like.errors.full_messages.join(', ')
    end
  end

  private
  def find_idea
    @idea = Idea.find(params[:idea_id])
  end

  def find_like
    @like = Like.find(params[:id])
  end
end
