require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
   end

   describe "新規登録機能" do
    context "登録がうまく行く時" do
      it "nickname,email,password,profile,imageが存在すれば登録できる" do
        expect(@user).to be_valid
      end
      it "nicknameが40文字以内なら登録できる" do
        @user.nickname = "1234567890123456789012345678901234567890"
        expect(@user).to be_valid
      end
      it "passwordが6文字以上で尚且つ、半角英数混合なら登録できる" do
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
       it "nicknameが空だと登録できない" do
        @user.nickname = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end
      it "nicknameが41以上だと登録できない" do
        @user.nickname = "12345678901234567890123456789012345678901"
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname is too long (maximum is 40 characters)")
      end
      it "passwordが空だと登録できない" do
        @user.password = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end
      it "passwordが5文字以下だと登録できない" do
        @user.password = "1234a"
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      end
      it "passwordが半角英字のみだと登録できない" do
        @user.password = "abcdef"
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is invalid")
      end
      it "passwordが半角数字のみだと登録できない" do
        @user.password = "123456"
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is invalid")
      end
      it "passwordに全角が入ると登録できない" do
        @user.password = "abcdf１"
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is invalid")
      end
      it "password_confirmationが空だと登録できない" do
        @user.password_confirmation = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it "passwordとpassword_confirmationが一致しないと登録できない" do
        @user.password = "12345a"
        @user.password_confirmation = "12345b"
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it "emailが空だと登録できない" do
        @user.email = ""
        @user.valid?
       expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      it "重複したemailだと登録できない" do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include("Email has already been taken")
      end
      it "emailに@が含まれていないと登録できない" do
        @user.email = "aaa.com"
        @user.valid?
        expect(@user.errors.full_messages).to include("Email is invalid")
      end
      it "profileが151文字以上だと登録できない" do
        @user.profile = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901"
        @user.valid?
        expect(@user.errors.full_messages).to include("Profile is too long (maximum is 150 characters)")
      end
    end
  end
end
