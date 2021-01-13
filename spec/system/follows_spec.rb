require 'rails_helper'

RSpec.describe "Follows", type: :system do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
  end

  context 'フォローができるとき' do
    it "ログインしたユーザーはフォローができる" do
      #トップページに遷移する
      visit root_path
      #ユーザー1でログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user1.email
      fill_in 'user_password', with: @user1.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      #ユーザー2のユーザーページに遷移する
      visit user_path(@user2)
      #フォローボタンがあることを確認する
      expect(page).to have_selector('.follow-to-btn')
      #フォローするとfollow_relationshipモデルのカウントが1増えることを確認する
      expect(FollowRelationship.count).to  eq 0
      find('input[value="フォローする"]').click
      visit user_path(@user2)
      expect(FollowRelationship.count).to  eq 1
      #ユーザー1のフォローページにユーザー2が存在することを確認する
      visit following_user_path(@user1)
      expect(page).to have_content("#{@user2.nickname}")
      expect(page).to have_content("#{@user2.profile}")
      #ユーザー2のフォワーページにユーザー1が存在することを確認する
      visit followers_user_path(@user2)
      expect(page).to have_content("#{@user1.nickname}")
      expect(page).to have_content("#{@user1.profile}")
      #フォローを外すとfollow_relationshipモデルのカウントが1減ることを確認する
      expect(FollowRelationship.count).to  eq 1
      find('input[value="フォロー中"]').click
      visit user_path(@user2)
      expect(FollowRelationship.count).to  eq 0
    end
  end

  context 'フォローができないとき' do
    it " ログインしていないユーザーはフォローボタンが表示されない" do
      #トップページに遷移する
      visit root_path
      #ユーザー1のユーザーページに遷移する
      visit user_path(@user1)
      #フォローボタンが存在しないことを確認する
      expect(page).to have_no_selector('.follow-to-btn')
    end
  end
end