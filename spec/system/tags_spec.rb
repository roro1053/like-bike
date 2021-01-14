require 'rails_helper'

RSpec.describe 'タグの編集', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
  end

  context 'タグ編集ができるとき' do
    it 'アイテムを投稿したユーザーはタグを編集できる' do
      # アイテムを投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'user_email', with: @item.user.email
      fill_in 'user_password', with: @item.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # アイテム一覧に遷移する
      visit items_path
      # アイテム詳細ページに遷移する
      visit item_path(@item)
      # タグを編集するボタンがあることを確認する
      expect(page).to have_content 'タグを編集'
      # タグの編集ページに遷移する
      visit edit_item_path(@item)
      # タグを編集する
      fill_in 'item_tag_ids', with: 'tag'
      # 更新をするとタグモデルのカウントが変わることを確認する
      expect  do
        click_button('更新')
      end.to change { Tag.count }.by(1)
      # アイテム詳細ページに遷移することを確認する
      expect(current_path).to eq item_path(@item)
      # 編集したタグが存在することを確認する
      expect(page).to have_content('tag')
      # タグ編集ページに遷移する
      visit edit_item_path(@item)
      # タグフォームを空にして、配列を入力する
      fill_in 'item_tag_ids', with: nil
      fill_in 'item_tag_ids', with: 'test edit'
      # 更新する
      click_button('更新')
      # アイテム詳細ページに遷移することを確認する
      expect(current_path).to eq item_path(@item)
      # タグ「tag」が存在しないことを確認する
      expect(page).to have_no_content('tag')
      # 編集したタグが存在することを確認する
      expect(page).to have_content 'test'
      expect(page).to have_content 'edit'
    end
  end
  context 'タグ編集ができないとき' do
    it 'アイテムを投稿したユーザーでなければタグを編集するボタンが表示されない' do
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
      # タグを編集するボタンが存在しないことを確認する
      expect(page).to have_no_content('タグを編集')
    end
    it 'ログインしていないユーザーにはタグを編集するボタンが表示されない' do
      # アイテム詳細ページに遷移する
      visit item_path(@item)
      # タグを編集するボタンが存在しないことを確認する
      expect(page).to have_no_content('タグを編集')
    end
  end
end

RSpec.describe 'タグの絞り込み検索', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end
  it 'タグをクリックすると絞り込み検索を行う（一覧、詳細）' do
    # アイテム1を投稿したユーザーでログインする
    visit new_user_session_path
    fill_in 'user_email', with: @item1.user.email
    fill_in 'user_password', with: @item1.user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
    # アイテム一覧ぺージに遷移する
    visit items_path
    # アイテム1と2が存在することを確認する
    expect(page).to have_content(@item1.name.to_s)
    expect(page).to have_content(@item2.name.to_s)
    # アイテム詳細ページに遷移する
    visit item_path(@item1)
    expect(page).to have_content(@item1.name.to_s)
    expect(page).to have_content(@item1.text.to_s)
    expect(page).to have_content('タグを編集')
    # タグ編集ページに遷移する
    visit edit_item_path(@item1)
    # 入力フォームに入力する
    fill_in 'item_tag_ids', with: 'tag'
    # 更新する
    expect  do
      click_button('更新')
    end.to change { Tag.count }.by(1)
    # アイテム詳細ページに遷移することを確認する
    expect(current_path).to eq item_path(@item1)
    # 編集したタグが存在することを確認する
    expect(page).to have_content('tag')
    # タグをクリックする
    click_on('tag')
    # アイテム一覧ページに遷移することを確認する
    expect(current_path).to eq items_path
    # タグが存在することを確認する
    expect(page).to have_content('tag')
    # 絞り込み検索が行われている（アイテム2が存在しない）ことを確認する
    expect(page).to have_content(@item1.name.to_s)
    expect(page).to have_no_content(@item2.name.to_s)
    # アイテム一覧ページに遷移する
    visit items_path
    expect(page).to have_content(@item1.name.to_s)
    expect(page).to have_content(@item2.name.to_s)
    # タグをクリックする
    click_on('tag')
    # アイテム一覧ページに遷移することを確認する
    expect(current_path).to eq items_path
    # タグが存在することを確認する
    expect(page).to have_content('tag')
    # 絞り込み検索が行われている（アイテム2が存在しない）ことを確認する
    expect(page).to have_content 'タグ「tag」を含むアイテム'
    expect(page).to have_content(@item1.name.to_s)
    expect(page).to have_no_content(@item2.name.to_s)
  end
end
