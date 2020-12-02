require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
  @comment = FactoryBot.build(:comment)
  end


describe "コメント投稿" do
  context "コメント投稿がうまくいく時" do
    it "textとimageが存在すれば投稿できる" do
      expect(@comment).to be_valid
    end
    it "textが存在すればimageが空でも投稿できる" do
      @comment.image = nil
      expect(@comment).to be_valid
    end
    it "imageが存在すればtextが空でも投稿できる" do
      @comment.text = ""
      expect(@comment).to be_valid
    end
    it "textが150字以内なら投稿できる" do
      @comment.text = "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
      expect(@comment).to be_valid
    end
  context "コメント投稿がうまくいかない時" do
    it "imageとtextが空だと投稿できない" do
      @comment.image = nil
      @comment.text = ""
      @comment.valid?
      expect(@comment.errors.full_messages).to include("Text can't be blank")
    end
    it "imageが存在せず、textが151文字以上だと投稿できない" do
      @comment.image = nil
      @comment.text = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901"
      @comment.valid?
      expect(@comment.errors.full_messages).to include("Text is too long (maximum is 150 characters)")
    end
    it "imageは存在するが、textが151文字以上だと投稿できない" do
      @comment.text = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901"
      @comment.valid?
      expect(@comment.errors.full_messages).to include("Text is too long (maximum is 150 characters)")
    end
      end
    end
  end
end
