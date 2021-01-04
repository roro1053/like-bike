require 'rails_helper'

RSpec.describe "Reviews", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
    @review = FactoryBot.create(:review)
  end

    context "レビューできる時" do
      it "ログインしたユーザーはレビューを投稿できる" do
      # ログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # アイテム一覧ページに遷移する
      visit items_path
      # アイテム詳細ページに遷移する
      visit item_path(@item)
      # 投稿フォームに入力する
      fill_in 'review_text', with: @review.text
      # レビューを書くとReviewモデルのレコードが1増えることを確認する
      expect{
        click_button('レビューを投稿する')
      }.to change { Review.count }.by(1)
      # アイテム詳細ページに遷移することを確認する
      expect(current_path).to eq item_path(@item)
      # アイテム詳細ページに投稿したレビューの内容が存在する
      expect(page).to have_selector ".review-rating-star"
      expect(page).to have_content @review.text
      # アイテム一覧ページに遷移する
      visit items_path
      # アイテム一覧に投稿したレビューの件数が表示されていることを確認する
      expect(
        all(".post-index")[1]
      ).to  have_content('1件のレビュー')
      end
    end
    context "レビューできない時" do
      it "ログインしていないユーザーはレビュー投稿欄が表示されない" do
        # トップページに遷移する
        visit root_path
        # アイテム一覧に遷移する
        visit items_path
        # アイテム詳細ページに遷移する
        visit item_path(@item)
        # レビュー投稿欄が表示されないことを確認する
        expect(page).to have_no_content "レビューを投稿する"
      end
      it "誤った情報ではレビューが投稿できずにアイテム詳細ページに留まる" do
        # ログインする
        visit new_user_session_path
        fill_in 'user_email', with: @user.email
        fill_in 'user_password', with: @user.password
        find('input[name="commit"]').click
        expect(current_path).to eq root_path
        # アイテム一覧ページに遷移する
        visit items_path
        # アイテム詳細ページに遷移する
        visit item_path(@item)
        # レビュー投稿欄に空の情報を入力する
        fill_in 'review_text', with: ""
        # 投稿してもReviewモデルのレコードは増えないことを確認する
        expect{
          click_button('レビューを投稿する')
        }.to change { Review.count }.by(0)
        # アイテム詳細ページに留まることを確認する
        expect(current_path).to eq item_reviews_path(@item)
        # レビュー投稿に失敗するとエラーメッセージが表示される
        expect(page).to have_selector ".error-message"
      end
    end
end

RSpec.describe 'レビュー削除', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item =  FactoryBot.create(:item)
    @review = FactoryBot.create(:review)
  end
      context "レビュー削除ができるとき" do
        it "レビューを投稿したユーザーはレビューを駆除できる" do
          # ログインする
          visit new_user_session_path
          fill_in 'user_email', with: @user.email
          fill_in 'user_password', with: @user.password
          find('input[name="commit"]').click
          expect(current_path).to eq root_path
          # アイテム一覧ページに遷移する
          visit items_path
          # アイテム詳細ページに遷移する
          visit item_path(@item)
          # レビュー投稿欄に入力する
          fill_in 'review_text', with: @review.text
          # レビューを投稿する
          expect{
            click_button('レビューを投稿')
          }.to change { Review.count }.by(1)
          # アイテム詳細ページに投稿したレビューが存在することを確認する
          expect(page).to have_selector ".review-rating-star"
          expect(page).to have_content @review.text
          # レビュー削除ボタンがあることを確認する
          expect(page).to have_content "レビューを削除"
          # レビューを削除するとReveiwモデルのレコードが1減ることを確認する
          expect{
            click_on('レビューを削除')
          }.to change { Review.count }.by(-1)
          # アイテム詳細ページに遷移することを確認する
          expect(current_path).to eq item_path(@item)
          # 削除したレビューが存在しないことを確認する
          expect(page).to have_no_content @review.text
        end
      end
      context "レビュー削除ができない時" do
        it "レビューをしたユーザーでなければ削除ボタンが表示されない" do
          # ログインする
          visit new_user_session_path
          fill_in 'user_email', with: @item.user.email
          fill_in 'user_password', with: @item.user.password
          find('input[name="commit"]').click
          expect(current_path).to eq root_path
          # アイテム一覧ページに遷移する
          visit items_path
          # アイテム詳細ページに遷移する
          visit item_path(@item)
          # レビュー投稿欄に入力する
          fill_in 'review_text', with: @review.text
          # レビューを投稿する
          expect{
          click_button('レビューを投稿')
          }.to change { Review.count }.by(1)
          # アイテム詳細ページに投稿したレビューが存在することを確認する
          expect(page).to have_selector ".review-rating-star"
          expect(page).to have_content @review.text
          # レビュー削除ボタンがあることを確認する
          expect(page).to have_content "レビューを削除"
          # ログアウトする
          click_on('ログアウト')
          # 別のユーザーでログインする
          visit new_user_session_path
          fill_in 'user_email', with: @user.email
          fill_in 'user_password', with: @user.password
          find('input[name="commit"]').click
          expect(current_path).to eq root_path
          # アイテム一覧ページに遷移する
          visit items_path
          # アイテム一覧に投稿したレビューの件数が表示されていることを確認する
          expect(
            all(".post-index")[1]
          ).to  have_content('1件のレビュー')
          # アイテム詳細ページに遷移する
          visit item_path(@item)
          # アイテム詳細ページに投稿したレビューが存在することを確認する
          expect(page).to have_selector ".review-rating-star"
          expect(page).to have_content @review.text
          # レビュー削除ボタンが存在しないことを確認する
          expect(page).to have_no_content "レビューを削除"
        end
      it "ログインしていないユーザーには削除ボタンが表示されない" do
          # ログインする
          visit new_user_session_path
          fill_in 'user_email', with: @item.user.email
          fill_in 'user_password', with: @item.user.password
          find('input[name="commit"]').click
          expect(current_path).to eq root_path
          # アイテム一覧ページに遷移する
          visit items_path
          # アイテム詳細ページに遷移する
          visit item_path(@item)
          # レビュー投稿欄に入力する
          fill_in 'review_text', with: @review.text
          # レビューを投稿する
          expect{
          click_button('レビューを投稿する')
          }.to change { Review.count }.by(1)
          # アイテム詳細ページに投稿したレビューが存在することを確認する
          expect(page).to have_selector ".review-rating-star"
          expect(page).to have_content @review.text
          # レビュー削除ボタンがあることを確認する
          expect(page).to have_content "レビューを削除"
          #ログアウトする
          click_on('ログアウト')
          # アイテム一覧ページに遷移する
          visit items_path
          # アイテム一覧に投稿したレビューの件数が表示されていることを確認する
          expect(
           all(".post-index")[1]
          ).to  have_content('1件のレビュー')
          # アイテム詳細ページに遷移する
          visit item_path(@item)
          # アイテム詳細ページに投稿したレビューが存在することを確認する
          expect(page).to have_selector ".review-rating-star"
          expect(page).to have_content @review.text
          # レビュー削除ボタンが存在しないことを確認する
          expect(page).to have_no_content "レビューを削除"
        end
  end
end