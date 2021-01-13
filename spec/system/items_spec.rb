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
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
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
  it "誤った情報では投稿投稿されず、投稿ページにとどまる" do
    #トップページに遷移する
    visit root_path
    #ログインする
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
    #アイテム投稿ページへのリンクを確認する
    expect(page).to have_content('アイテムを投稿')
    #アイテム投稿ページに遷移する
    visit new_item_path
    #フォームに入力し、送信する
    fill_in 'item_tag_name', with: ""
    fill_in "item_tag_text",with: ""
    # 送信してもItemモデルのカウントが変わらないことを確認する
     expect{
      click_button('投稿する')
    }.to change { Item.count }.by(0)
    #投稿に失敗すると投稿ページにとどまる
    expect(current_path).to eq "/items"
    #投稿に失敗するとエラーメッセージが表示される
    expect(page).to have_content "name.blank"
    #expect(page).to have_content "image.blank"
  end
 end
end

RSpec.describe 'アイテム削除', type: :system do
  before do
    @item1 = FactoryBot.create(:item)
    @item2 = FactoryBot.create(:item)
  end

  context 'アイテム削除ができるとき' do
    it "アイテムを投稿したユーザーはアイテムを削除できる（一覧）" do
      #アイテム1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'user_email', with: @item1.user.email
      fill_in 'user_password', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # アイテム一覧に遷移する
      visit items_path
       #アイテム1に削除ボタンがあることを確認する
       expect(
         all(".post-index")[1]
       ).to  have_content('削除') 
        #アイテムを削除するとItemモデルのレコードが1減ることを確認する
      expect{
        click_link('削除')
      }.to change { Item.count }.by(-1)
      #アイテム一覧ページに遷移することを確認する
      expect(current_path).to eq items_path
      #削除したアイテムが存在しないことを確認する
      expect(page).to have_no_content("#{@item1.name}")
      expect(page).to have_no_content("#{@item1.text}")
    end
    it "アイテムを投稿したユーザーはアイテムを削除できる（詳細）" do
      #アイテム1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'user_email', with: @item1.user.email
      fill_in 'user_password', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # アイテム一覧に遷移する
      visit items_path
       #アイテム1に削除ボタンがあることを確認する
       expect(
         all(".post-index")[1]
       ).to  have_content('削除') 
      #アイテム詳細ページに遷移する
      visit item_path(@item1)
      #削除ボタンを確認する
      expect(page).to have_content "削除"
      #アイテムを削除するとItemモデルのレコードが1減ることを確認する
      expect{
        click_link('削除')
      }.to change { Item.count }.by(-1)
      #アイテム一覧ページに遷移することを確認する
      expect(current_path).to eq items_path
      #削除したアイテムが存在しないことを確認する
      expect(page).to have_no_content("#{@item1.name}")
      expect(page).to have_no_content("#{@item1.text}")
    end
  end

  context 'アイテム削除ができないとき' do
    it "アイテムを投稿したユーザーでなければ削除ボタンが表示されない(一覧)" do
      #アイテム1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'user_email', with: @item1.user.email
      fill_in 'user_password', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # アイテム一覧に遷移する
      visit items_path
       #アイテム2に削除ボタンが存在しないことを確認する
       expect(
         all(".post-index")[0]
       ).to  have_no_content('削除')
    end

    it "アイテムを投稿したユーザーでなければ削除ボタンが表示されない(詳細)" do
      #アイテム1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'user_email', with: @item1.user.email
      fill_in 'user_password', with: @item1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # アイテム一覧に遷移する
      visit items_path
       #アイテム2に削除ボタンが存在しないことを確認する
       expect(
         all(".post-index")[0]
       ).to  have_no_content('削除') 
      #アイテム2の詳細ページに遷移する
      visit item_path(@item2)
      #削除ボタンを確認する
      expect(page).to have_no_content "削除"
    end
    it "ログインしていないユーザには削除ボタンが表示されない（一覧、詳細）" do
      #アイテム一覧ページに遷移する
      visit items_path
      #アイテム一覧ページに削除ボタンが表示されないことを確認する
      expect(page).to have_no_content "削除"
      #アイテム詳細ページに遷移する
      visit item_path(@item1)
      #詳細ページにて削除ボタンが存在しないことを確認する
      expect(page).to have_no_content "削除"
    end
 end
end

RSpec.describe 'アイテム詳細', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
  end
    it "ログインしたユーザーにはレビュー投稿欄が表示される" do
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
      # 詳細ページに投稿の内容が含まれている
      expect(page).to have_selector(".show-image[src$='test_image.png']")
      expect(page).to have_content("#{@item.text}")
      # 削除ボタンがあることを確認する
      expect(page).to have_content "削除"
      # レビュー用のフォームが存在する
      expect(page).to have_content"レビューを書く"
    end

    it "ログインしていないユーザーにはレビュー投稿欄が表示されない" do
      # アイテム詳細ページに遷移する
      visit item_path(@item)
      # 詳細ページに投稿の内容が含まれている
      expect(page).to have_selector(".show-image[src$='test_image.png']")
      expect(page).to have_content("#{@item.text}")
      # 削除ボタンが存在しないことを確認する
      expect(page).to have_no_content "削除"
      # レビュー用のフォームが存在しないことを確認する
      expect(page).to have_no_content "レビューを書く"
    end
end
RSpec.describe 'アイテム検索', type: :system do
  before do
    @user = FactoryBot.create(:user)
    
  end
    it "ログインしたユーザーはアイテムを検索できる" do
      # ログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # アイテムページに遷移する
      visit items_path
      # アイテム投稿ページに遷移する
      visit new_item_path
      # フォームに入力し、送信する
      fill_in 'item_tag_name', with: "item-name"
      fill_in "item_tag_text",with: "item-text"
      attach_file "item_tag_image", "public/images/test_image.png"
      fill_in "tag-field",with: "item-tag"
      # 送信するとItemモデルのカウントが1上がることを確認する
      expect{
      click_button('投稿する')
      }.to change { Item.count }.by(1)
      # アイテム一覧ページに遷移することを確認する
      expect(current_path).to eq items_path
      # 投稿したアイテムが存在することを確認する
      expect(page).to have_content "item-name"
      expect(page).to have_content "item-text"
      expect(page).to have_selector(".post-img[src$='test_image.png']")
      expect(page).to have_content "item-tag"
      # 検索フォームに入力する
      fill_in 'keyword', with: "name"
      click_button('検索')
      # 検索結果ページに遷移することを確認する
      expect(current_path).to eq locate_items_path
      # 検索フォームに入力した内容で検索されていることを確認する
      expect(page).to have_content "nameの検索結果"
      # 検索フォームで入力したキーワードと合致するアイテムが存在することを確認する(item.name)
      expect(page).to have_selector(".post-index")
      # 検索フォームに入力する
      fill_in 'keyword', with: "text"
      click_button('検索')
      # 検索結果ページに遷移することを確認する
      expect(current_path).to eq locate_items_path
      # 検索フォームに入力した内容で検索されていることを確認する
      expect(page).to have_content "textの検索結果"
      # 検索フォームで入力したキーワードと合致するアイテムが存在することを確認する(item.text)
      expect(page).to have_selector(".post-index")
      # 検索フォームに入力する
      fill_in 'keyword', with: "tag"
      click_button('検索')
      # 検索結果ページに遷移することを確認する
      expect(current_path).to eq locate_items_path
      # 検索フォームに入力した内容で検索されていることを確認する
      expect(page).to have_content "tagの検索結果"
      # 検索フォームで入力したキーワードと合致するアイテムが存在することを確認する(tag.word)
      expect(page).to have_selector(".post-index")
      # 検索フォームに入力する
      fill_in 'keyword', with: "test"
      click_button('検索')
      # 検索結果ページに遷移することを確認する
      expect(current_path).to eq locate_items_path
      # 検索フォームに入力した内容で検索されていることを確認する
      expect(page).to have_content "testの検索結果"
      # 検索フォームで入力したキーワードと合致するアイテム(name,text,tag)が存在しないことを確認する
      expect(page).to have_no_selector(".post-index")
    end
    it "ログインしていないユーザーが検索するとログインページに遷移する" do
      # ログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # アイテムページに遷移する
      visit items_path
      # アイテム投稿ページに遷移する
      visit new_item_path
      # フォームに入力し、送信する
      fill_in 'item_tag_name', with: "item-name"
      fill_in "item_tag_text",with: "item-text"
      attach_file "item_tag_image", "public/images/test_image.png"
      fill_in "tag-field",with: "item-tag"
      # 送信するとItemモデルのカウントが1上がることを確認する
      expect{
      click_button('投稿する')
      }.to change { Item.count }.by(1)
      # アイテム一覧ページに遷移することを確認する
      expect(current_path).to eq items_path
      # 投稿したアイテムが存在することを確認する
      expect(page).to have_content "item-name"
      expect(page).to have_content "item-text"
      expect(page).to have_selector(".post-img[src$='test_image.png']")
      expect(page).to have_content "item-tag"
      # ログアウトする
      click_link('ログアウト')
      # アイテム一覧ページに遷移する
      visit items_path
      # 検索フォームに入力する
      fill_in 'keyword', with: "item"
      click_button('検索')
      # ログインページに遷移することを確認する
      expect(current_path).to eq new_user_session_path
    end
end