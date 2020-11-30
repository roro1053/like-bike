class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :show, :update, :destroy]

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
  end

  def destroy
   unless user_signed_in? && current_user.id == @post.user_id
      render :index 
    end

    if @post.destroy
      redirect_to root_path 
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to root_path(@item_id)
    else
      render :edit
    end
  end

private

def set_post
  @post = Post.find(params[:id])
end

def post_params
  params.require(:post).permit(:text,:image).merge(user_id: current_user.id)
end

end
