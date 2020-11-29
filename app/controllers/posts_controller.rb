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
    @post = Post.find(params[:id])

   unless user_signed_in? && current_user.id == @post.user_id
      render :index 
    end

    if @post.destroy
      redirect_to root_path 
    end
  end

private

def post_params
  params.require(:post).permit(:text,:image).merge(user_id: current_user.id)
end

end
