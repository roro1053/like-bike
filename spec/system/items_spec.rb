require 'rails_helper'

RSpec.describe "Items", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.build(:item)
  end

  context 'アイテム投稿ができるとき'do
  it "ログインしたユーザーはアイテムを投稿できる" do
    #トップページに遷移する
    visit root_path
    #ログインする
    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
    #アイテム投稿ページへのリンクを確認する
    expect(page).to have_content('アイテムを投稿')
    #アイテム投稿ページに遷移する
    visit new_item_path
    #フォームに入力し、送信する
    fill_in 'item_tag_name', with: @item.name
    fill_in "item_tag_text",with: @item.text
    attach_file "item_tag_image", "public/images/test_image.png"
    fill_in "tag-field",with: "tag"
     # 送信するとItemモデルのカウントが1上がることを確認する
     expect{
      click_button('投稿する')
    }.to change { Item.count }.by(1)
    #アイテム一覧ページに遷移することを確認する
    expect(current_path).to eq items_path
    #投稿したアイテムが存在することを確認する
    expect(page).to have_content @item.name
    expect(page).to have_content @item.text
    expect(page).to have_selector(".post-img[src$='test_image.png']")
    expect(page).to have_content "tag"
  end

  end
  context 'アイテム投稿ができない時'do
  it "ログインしないとアイテム投稿が表示されない" do
    #トップページに遷移する
    visit root_path
    #アイテム投稿へのリンクが表示されない
    expect(page).to have_no_content('アイテムを投稿')
  end
 end
end
