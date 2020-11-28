require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
   end

   describe "新規登録" do
    context "登録がうまく行く時" do
      it "nickname,email,passwordが存在すれば登録できる" do
        expect(@user).to be_valid
      end
     end
    context "登録がうまくいかない時" do
      
    end
   end
end
