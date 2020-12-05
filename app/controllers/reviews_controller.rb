class ReviewsController < ApplicationController

  def create
    @review = Review.new(review_params)
    if @review.valid?
      @review.save
    redirect_to "/items/#{@review.item.id}"
    else 
      @post = @comment.post
      @comments = @post.comments
      render "posts/show"
    end
  end

  private 
  def review_params
    params.require(:review).permit(:text,).merge(user_id: current_user.id, item_id: params[:item_id],rating: params[:rating])
  end
end
