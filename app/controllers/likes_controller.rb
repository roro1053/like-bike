class LikesController < ApplicationController
  before_action :set_like, only: [:create, :destroy]

  def create
    @like = Like.create(user_id: current_user.id, post_id: params[:post_id])
    @likes = Like.where(post_id: params[:post_id])
  end

  def destroy
    @like = Like.find_by(user_id: current_user.id, post_id: params[:post_id])
    @like.destroy
  end

  private
  def set_like
    @post = Post.find(params[:post_id])
  end
end
