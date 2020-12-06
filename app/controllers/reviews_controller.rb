class ReviewsController < ApplicationController


  def create
    @review = Review.new(review_params)
    if @review.valid?
      @review.save
    redirect_to "/items/#{@review.item.id}"
    else 
      @item = @review.item
      @reviews = @item.reviews
      render "items/show"
    end
  end

  def destroy
    @review = Review.find_by(id: params[:id],item_id: params[:item_id])
    if @review.destroy
      redirect_to root_path 
    end
  end

  private 
  def review_params
    params.require(:review).permit(:text,).merge(user_id: current_user.id, item_id: params[:item_id],rating: params[:rating])
  end
end
