class PostsController < ApplicationController

  def index
    @posts = Post.includes(:user).order('created_at DESC')
  end
   
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.valid?
    @post.save
    redirect_to root_path(@post)
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    redirect_to root_path unless user_signed_in? && current_user.id == @post.user_id

    redirect_to root_path if @post.destroy
  end

private

def post_params
  params.require(:post).permit(:text,:image).merge(user_id: current_user.id)
end

end
