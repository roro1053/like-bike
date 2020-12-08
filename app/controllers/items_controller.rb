class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: [:show,:destroy]

  def index
    @items = Item.includes(:user).order('created_at DESC')
  end

  def new
    @item = ItemTag.new
  end

  def create
    @item = ItemTag.new(item_params)
    if @item.valid?
      @item.save
      redirect_to items_path(@item)
    else
      render :new
    end
  end

  def show
    @review = Review.new
    @reviews = @item.reviews.includes(:user).order('created_at DESC')
  end

  def destroy
    unless user_signed_in? && current_user.id == @item.user_id
      render root_path
    end

    if @item.destroy
      redirect_to items_path
    end
  end
  
  def search
      return nil if params[:keyword] == ""
      tag = Tag.where(['word LIKE ?', "%#{params[:keyword]}%"] )
      render json:{ keyword: tag }
  end
  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item_tag).permit(:name,:text,:image,:word).merge(user_id: current_user.id)
  end

  def item_tag_params
    params.require(:item_tag).permit(:name)
  end
end
