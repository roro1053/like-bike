require 'rails_helper'

RSpec.describe Tag, type: :model do
  before do
  @tag = FactoryBot.build(:tag)
  end

  describe 'タグの登録' do
    context 'タグの登録がうまく行く時' do
      it "wordが存在すれば登録できる" do
      expect(@tag).to be_valid
      end
    end
    context 'タグの登録がうまくいかない時' do
      it "wordが41文字以上だと登録できない" do
        @tag.word = "12345678901234567890123456789012345678901"
        @tag.valid?
        expect(@tag.errors.full_messages).to include("Word translation missing: ja.activerecord.errors.models.tag.attributes.word.too_long")
      end
    end
  end
end
