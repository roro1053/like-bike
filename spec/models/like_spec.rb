require 'rails_helper'

RSpec.describe Like, type: :model do
  before do
    @like = FactoryBot.build(:like)
  end

  describe 'いいねする' do
    context 'いいねできる' do
      it '投稿にいいねできる' do
        expect(@like).to be_valid
      end
    end
  end
end
