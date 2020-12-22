require 'rails_helper'

RSpec.describe "Comments", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @post = FactoryBot.create(:post)
    @comment = FactoryBot.create(:comment)
  end

  context 'コメントできるとき' do
  it 'ログインしたユーザーはツイート詳細ページでコメント投稿できる' do
    # ログインする
    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
    # 投稿詳細ページに遷移する
    visit post_path(@post)
    # フォームに情報を入力する
    fill_in 'comment_text', with: @comment.text
    attach_file "comment_image", "public/images/test_image.png"
    # コメントを送信すると、Commentモデルのカウントが1上がることを確認する
    expect{
      click_button('SEND')
    }.to change { Comment.count }.by(1)
    # 詳細ページにリダイレクトされることを確認する
    expect(current_path).to eq post_path(@post)
    # 詳細ページ上に先ほどのコメント内容が含まれていることを確認する
    expect(page).to have_selector(".comment-image[src$='test_image.png']")
    expect(page).to have_content @comment.text
  end
 end
 context 'コメントできないとき' do
  it "ログインユーザーでないとコメントできない" do
    #トップページに遷移する
    visit root_path
    #投稿詳細ページに遷移する
    visit post_path(@post)
    #コメントするフォームが存在しないことを確認する
    expect(page).to have_no_content("クリックしてファイルをアップロード")
  end
end
end

RSpec.describe 'コメント削除', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @post =  FactoryBot.create(:post)
    @comment = FactoryBot.create(:comment)
  end

  context "コメント削除できるとき" do
    it "コメントしたユーザーなら削除できる" do
      #コメント1を投稿したユーザーがログインする
      visit new_user_session_path
      fill_in 'Email', with: @comment.user.email
      fill_in 'Password', with: @comment.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      #投稿の詳細ページに遷移する
      visit post_path(@post)
      #フォームに情報を入力する
      fill_in 'comment_text', with: @comment.text
      attach_file "comment_image", "public/images/test_image.png"
      # コメントを送信すると、Commentモデルのカウントが1上がることを確認する
      expect{
        click_button('SEND')
      }.to change { Comment.count }.by(1)
      # 詳細ページにリダイレクトされることを確認する
      expect(current_path).to eq post_path(@post)
      # 詳細ページ上に先ほどのコメント内容が含まれていることを確認する
      expect(page).to have_selector(".comment-image[src$='test_image.png']")
      expect(page).to have_content @comment.text
      #削除ボタンを確認する
      expect(page).to have_content "削除する"
      #投稿を削除するとレコードの数が1減ることを確認する
      expect{
        click_link('削除する')
      }.to change { Comment.count }.by(-1)
      #コメントを削除すると、投稿の詳細ページに遷移する
      expect(current_path).to eq post_path(@post)
      #投稿したコメントが削除されている
      expect(page).to have_no_content("#{@comment.text}")
    end
  end
  context "コメント削除できないとき" do
    it "コメントしたユーザー以外には削除ボタンが表示されない" do
       #コメント1を投稿したユーザーがログインする
       visit new_user_session_path
       fill_in 'Email', with: @comment.user.email
       fill_in 'Password', with: @comment.user.password
       find('input[name="commit"]').click
       expect(current_path).to eq root_path
       #投稿の詳細ページに遷移する
       visit post_path(@post)
       #フォームに情報を入力する
       fill_in 'comment_text', with: @comment.text
       attach_file "comment_image", "public/images/test_image.png"
       # コメントを送信すると、Commentモデルのカウントが1上がることを確認する
       expect{
         click_button('SEND')
       }.to change { Comment.count }.by(1)
       # 詳細ページにリダイレクトされることを確認する
       expect(current_path).to eq post_path(@post)
       # 詳細ページ上に先ほどのコメント内容が含まれていることを確認する
       expect(page).to have_selector(".comment-image[src$='test_image.png']")
       expect(page).to have_content @comment.text
       #削除ボタンを確認する
       expect(page).to have_content "削除する"
       
    end
    it "ログアウトユーザーには削除ボタンが表示されない" do
      
    end
  end


end

 


