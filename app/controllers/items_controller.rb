class ItemsController < ApplicationController

  def index
    @items = Item.includes(:user).order('created_at DESC')
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.valid?
    @item.save
    redirect_to items_path(@item)
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
    @review = Review.new
    @reviews = @item.reviews.includes(:user).order('created_at DESC')
  end

  def destroy
    @item = Item.find(params[:id])
    if @item.destroy
      redirect_to root_path
    end
  end

  private
  def item_params
    params.require(:item).permit(:name,:text,:image).merge(user_id: current_user.id)
  end
end
