require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
   end

   describe "新規登録" do
    context "登録がうまく行く時" do
      it "nickname,email,password,profile,imageが存在すれば登録できる" do
        expect(@user).to be_valid
      end
      it "nicknameが40文字以内なら登録できる" do
        @user.nickname = "1234567890123456789012345678901234567890"
        expect(@user).to be_valid
      end
      it "passwordが6文字以上で尚且つ、英数混合なら登録できる" do
        @user.password = "12345a"
        @user.password_confirmation = "12345a"
        expect(@user).to be_valid
      end
      it "profileが空でも登録できる" do
        @user.profile = ""
        expect(@user).to be_valid
      end
      it "imageが空でも登録できる" do
        @user.image = nil
        expect(@user).to be_valid
      end
      it "profileとimageが空でも登録できる" do
        @user.profile = ""
        @user.image = nil
        expect(@user).to be_valid
      end

     end
    context "登録がうまくいかない時" do
       it "" do
        
      end
    end
   end
end
