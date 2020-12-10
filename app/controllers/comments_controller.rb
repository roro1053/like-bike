class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.create(comment_params)
    if @comment.valid?
      @comment.save
      redirect_to "/posts/#{@comment.post.id}"
    else
      @post = @comment.post
      @comments = @post.comments
      render 'posts/show'
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id], post_id: params[:post_id])
    render root_path unless user_signed_in? && current_user.id == @comment.user_id
    redirect_to "/posts/#{@comment.post.id}" if @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:text, :image).merge(user_id: current_user.id, post_id: params[:post_id])
  end
end
