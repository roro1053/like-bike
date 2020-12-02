class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show,:search]
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
    @comment = Comment.new
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
    unless user_signed_in? && current_user.id == @post.user_id
      redirect_to action: :index
      return
    end
  end

  def update
    if @post.update(post_params)
      redirect_to root_path(@item_id)
    else
      render :edit
    end
  end

  def search
    
    @posts = Post.search(params[:keyword]).includes(:user).order('created_at DESC')
  end

private

def set_post
  @post = Post.find(params[:id])
end

def post_params
  params.require(:post).permit(:text,:image).merge(user_id: current_user.id)
end

end
