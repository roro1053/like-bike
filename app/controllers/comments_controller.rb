class CommentsController < ApplicationController

  def create
    @comment = Comment.create(comment_params)
    if @comment.valid?
      @comment.save
    redirect_to "/posts/#{@comment.post.id}"
    else 
      @post = @comment.post
      @comments = @post.comments
      render "posts/show"
    end
  end

  private 
  def comment_params
    params.require(:comment).permit(:text,:image).merge(user_id: current_user.id, post_id: params[:post_id])
  end
end
