require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end
  describe 'アイテム投稿' do
    context 'アイテム投稿がうまくいく時' do
      it 'name,text,imageが存在すれば投稿できる' do
        expect(@item).to be_valid
      end
      it 'nameとimageがあれば投稿できる' do
        @item.text = ""
        expect(@item).to be_valid
      end
      it 'nameが40文字以内なら投稿できる' do
        @item.name = "1234567890123456789012345678901234567890"
        expect(@item).to be_valid
      end
      it 'textが150文字以内なら投稿できる' do
        @item.text = "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
        expect(@item).to be_valid
      end
    end
    context 'アイテム投稿がうまくいかない時' do
      it "nameが存在しないと投稿できない" do
        @item.name = ""
        @item.valid?
        expect(@item.errors.full_messages).to include("Name translation missing: ja.activerecord.errors.models.item.attributes.name.blank")
      end
      it "imageが存在しないと投稿できない" do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Image translation missing: ja.activerecord.errors.models.item.attributes.image.blank")
      end
      it "nameとimageが存在しないと投稿できない" do
        @item.name = ""
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Name translation missing: ja.activerecord.errors.models.item.attributes.name.blank", "Image translation missing: ja.activerecord.errors.models.item.attributes.image.blank")
      end
      it "textが151文字以上だと登録できない" do
        @item.text = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901"
        @item.valid?
        expect(@item.errors.full_messages).to include("Text translation missing: ja.activerecord.errors.models.item.attributes.text.too_long") 
      end
      it "nameが41文字以上だと投稿できない" do
        @item.name = "12345678901234567890123456789012345678901"
        @item.valid?
        expect(@item.errors.full_messages).to include("Name translation missing: ja.activerecord.errors.models.item.attributes.name.too_long")
      end
     
    end
  end
end
