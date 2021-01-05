class UsersController < ApplicationController
  before_action :set_user, only: [:show, :item,:like,:following,:followers]

  def show
    @posts = @user.posts.includes(:user).order('created_at DESC')
  end

  def item
    @items = @user.items.includes(:user).order('created_at DESC')
  end

  def like
    @like_posts = @user.liked_posts.includes(:user).order('created_at DESC')
  end

  def following
    @users = @user.followings
    render 'show_following'
  end

  def followers
    @users = @user.followers
    render 'show_followers'
  end

  private

  def set_user
    @user = User.find(params[:id])
    @nickname = @user.nickname
  end
end
