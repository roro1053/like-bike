class UsersController < ApplicationController

 def show
  user = User.find(params[:id])
  @nickname = user.nickname
  @posts = user.posts.includes(:user).order('created_at DESC')
 end

 def item
  user = User.find(params[:id])
  @nickname = user.nickname
  @items = user.items.includes(:user).order('created_at DESC')
 end

end
