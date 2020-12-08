class UsersController < ApplicationController
  before_action :set_user, only: [:show,:item]

 def show
  @posts = @user.posts.includes(:user).order('created_at DESC')
 end

 def item
  @items = @user.items.includes(:user).order('created_at DESC')
 end

private
  def set_user
    @user = User.find(params[:id])
    @nickname = @user.nickname
  end
end
