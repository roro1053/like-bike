class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: [:show, :destroy, :edit, :update]

  def index
    if params[:word].present?
      @tag = Tag.find(params[:word])
      @items = @tag.items.order(created_at: :desc)
    else
      @items = Item.includes(:user).order('created_at DESC')
    end
  end

  def new
    @item = ItemTag.new
  end

  def create
    @item = ItemTag.new(itemtags_params)
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
    render root_path unless user_signed_in? && current_user.id == @item.user_id

    redirect_to items_path if @item.destroy
  end

  def search
    return nil if params[:keyword] == ''

    tag = Tag.where(['word LIKE ?', "%#{params[:keyword]}%"])
    render json: { keyword: tag }
  end

  def locate
    @items = Item.locate(params[:keyword]).includes(:user).order('created_at DESC')
  end

  def edit
    unless user_signed_in? && current_user.id == @item.user_id
      redirect_to action: :index
      nil
    end
    @tag_list = @item.tags.pluck(:word).join(' ')
  end

  def update
    tag_list = params[:item][:tag_ids].split(/[[:blank:]]+/).select(&:present?)
    if @item.update_attributes(item_params)
      @item.save_tags(tag_list)
      redirect_to @item
    else
      render 'edit'
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :text, :image).merge(user_id: current_user.id)
  end

  def itemtags_params
    params.require(:item_tag).permit(:name, :text, :image, :tag_ids).merge(user_id: current_user.id)
  end
end
