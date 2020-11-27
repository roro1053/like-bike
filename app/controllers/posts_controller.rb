class PostsController < ApplicationController

  def index
    
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

private

def post_params
  params.require(:post).permit(:text,:image).merge(user_id: current_user.id)
end

end
