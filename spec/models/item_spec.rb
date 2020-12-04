require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
   end
   describe "アイテム投稿" do
    context "アイテム投稿がうまくいく時" do
      it "name,text,imageが存在すれば投稿できる" do
        expect(@item).to be_valid
      end
      it "" do
        
      end
      it "" do
        
      end
      it "" do
        
      end

    end
    context "アイテム投稿がうまくいかない時" do
      
    end
    
   end
end
