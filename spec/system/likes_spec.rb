require 'rails_helper'

RSpec.describe "Likes", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @post = FactoryBot.create(:post)
  end

  context "いいねできる時" do
    it "ログインしたユーザーは投稿にいいねできる（一覧）" do
      # トップページに移動する
      visit root_path
      # ログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 投稿一覧にいいねボタンが存在することを確認する
      expect(page).to have_selector('.posts-like-btn')
      # いいねするとLikeモデルのレコードが1増えることを確認する
      expect(Like.count).to  eq 0
      click_link('0')
      visit posts_path
      expect(Like.count).to  eq 1
      # もう一度いいねをするとlikeモデルのレコードが1減ることを確認する（1人ができるいいねは投稿に対して1回まで）
      expect(Like.count).to  eq 1
      click_link('1')
      visit posts_path
      expect(Like.count).to  eq 0
    end
    it "ログインしたユーザーは投稿にいいねできる（詳細)" do
      # トップページに移動する
      visit root_path
      # ログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 詳細ページに遷移する
      visit post_path(@post)
      # 詳細ページにいいねボタンがあることを確認する
      expect(page).to have_selector('.like-btn')
      # いいねするとLikeモデルのレコードが1増える
      expect(Like.count).to  eq 0
      click_link('0')
      visit post_path(@post)
      expect(Like.count).to  eq 1
      # もう一度いいねをするとLikeモデルのレコードが1減ることを確認する（1人ができるいいねは投稿に対して1回まで）
      expect(Like.count).to  eq 1
      click_link('1')
      visit post_path(@post)
      expect(Like.count).to  eq 0
    end
  end
  
  context "いいねできない時" do
    it "ログインしていないユーザーにはいいねボタンが表示されない（一覧、詳細）" do
      # トップページに遷移する
      visit root_path
      # いいねボタンが表示されないことを確認する
      expect(page).to have_no_selector('.posts-like-btn')
      # 投稿詳細ページに遷移する
      visit post_path(@post)
      # いいねボタンが表示されないことを確認する
      expect(page).to have_no_selector('.like-btn')
    end
  end
end