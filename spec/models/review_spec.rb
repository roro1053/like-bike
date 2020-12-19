require 'rails_helper'

RSpec.describe Review, type: :model do
  before do
    @review = FactoryBot.build(:review)
  end

  describe 'レビュー投稿' do
    context 'レビュー投稿がうまくいく時' do
      it "ratingとtextが存在すれば投稿できる" do
        expect(@review).to be_valid
      end
      it "textが150文字以内なら投稿できる" do
        @review.text = "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
        expect(@review).to be_valid
      end

    end
    context 'レビュー投稿がうまくいかない時' do
      it "ratingが空だと投稿できない" do
        @review.rating = ""
        @review.valid?
        expect(@review.errors.full_messages).to include("Rating translation missing: ja.activerecord.errors.models.review.attributes.rating.blank")
      end
      it "textが空だと投稿できない" do
        @review.text = ""
        @review.valid?
        expect(@review.errors.full_messages).to include("Text translation missing: ja.activerecord.errors.models.review.attributes.text.blank")
      end
      it "textが151文字以上だと投稿できない" do
        @review.text = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901"
        @review.valid?
        expect(@review.errors.full_messages).to include("Text translation missing: ja.activerecord.errors.models.review.attributes.text.too_long")
      end
      
    end
  end
end
