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
    end
  end
end
