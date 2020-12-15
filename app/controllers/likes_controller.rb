class LikesController < ApplicationController

  def create
    @like = Like.create(user_id: current_user.id, post: @post.id)
  end

  def destroy
    @like = Like.find_by(post_id: params[:@post_id], user_id: current_user.id)
    @like.destroy
  end

end
