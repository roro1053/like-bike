require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
   @post = FactoryBot.build(:post)
  end
  
  describe "新規投稿" do
    context "新規投稿がうまく行く時" do
      it "textとimageが存在すれば投稿できる" do
        expect(@post).to be_valid
      end
      it "imageが存在すればtextが空でも投稿できる" do
        @post.text = ""
        expect(@post).to be_valid
      end
      it "textが存在すればimageが空でも投稿できる" do
        @post.image = nil
        expect(@post).to be_valid
      end
    end

    context "新規投稿がうまくいかない時" do
      it "imageとtextが空だと投稿できない" do
        @post.image = nil
        @post.text = ""
        @post.valid?
        expect(@post.errors.full_messages).to include("Text can't be blank")
      end
      it "imageが存在せず、textが151文字以上だと投稿できない" do
        @post.image = nil
        @post.text = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901"
        @post.valid?
        expect(@post.errors.full_messages).to include("Text is too long (maximum is 150 characters)")
      end
      it "imageは存在するが、textが151文字以上だと投稿できない" do
        @post.text = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901"
        @post.valid?
        expect(@post.errors.full_messages).to include("Text is too long (maximum is 150 characters)")
      end
    end
  end
end
