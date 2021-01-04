require 'rails_helper'

RSpec.describe "Posts", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @post_text = Faker::Lorem.sentence
    @post_image = Faker::Lorem.sentence
  end

  context '投稿ができるとき'do
  it 'ログインしたユーザーは新規投稿できる' do
   # トップページに移動する
    visit root_path
   # ログインする
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
   # 新規投稿ページへのリンクがあることを確認する
    expect(page).to have_content('新規投稿')
   # 投稿ページに移動する
    visit new_post_path
   # フォームに情報を入力する
    fill_in 'post_text', with: @post_text
    attach_file "post_image", "public/images/test_image.png"
   # 送信するとPostモデルのカウントが1上がることを確認する
    expect{
     click_button('投稿する')
   }.to change { Post.count }.by(1)
   # トップページに遷移することを確認する 
    expect(current_path).to eq root_path
   # トップページには先ほど投稿した内容の投稿が存在することを確認する（画像）
    expect(page).to have_selector".post-img"
   # トップページには先ほど投稿した内容の投稿が存在することを確認する（テキスト）
    expect(page).to have_selector".post-text"
  end
 end
  context '投稿ができないとき'do
  it 'ログインしていないと新規投稿ページに遷移できない' do
  # トップページに遷移する
  visit root_path
  # 新規投稿ページへのリンクがない
  expect(page).to have_no_content('新規投稿')
  end

  it "誤った情報では新規投稿ができずに新規投稿ページへ戻ってくる" do
    #トップページに遷移する
    visit root_path
    #ログインする
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
    #投稿ページに移動する
    visit new_post_path
    #空の情報を入力する
    fill_in 'post_text', with: ""
    #送信してもPostモデルのカウントが増えないことを確認する
    expect{
      click_button('投稿する')
    }.to change { Post.count }.by(0)
    #新規投稿ページに留まることを確認する
    expect(current_path).to eq "/posts"
    #投稿に失敗するとエラーメッセージが表示されることを確認する
    expect(page).to have_selector".error-alert"
  end
end

end

RSpec.describe '投稿編集', type: :system do
  before do
    @post1 = FactoryBot.create(:post) 
    @post2 = FactoryBot.create(:post)
  end
  context '投稿編集ができるとき' do
    it 'ログインしたユーザーは自分が投稿した投稿の編集ができる' do
      # 投稿1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'user_email', with: @post1.user.email
      fill_in 'user_password', with: @post1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 投稿1に「編集」ボタンがあることを確認する
      expect(
        all(".post-index")[1]
      ).to  have_content('編集')
      # 編集ページへ遷移する
      visit edit_post_path(@post1)
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(
        find('#post_text').value
      ).to eq @post1.text
      # 投稿内容を編集する
      attach_file "post_image", "public/images/test_image2.png"
      fill_in 'post_text', with: "#{@post1.text}+編集したテキスト"
      # 編集してもPostモデルのカウントは変わらないことを確認する
      expect{
        click_button('変更する')
      }.to change { Post.count }.by(0)
      # トップページに遷移する
      expect(current_path).to eq root_path
      # トップページには先ほど変更した内容の投稿が存在することを確認する（画像）
      expect(page).to have_selector("img[src$='test_image2.png']")
      # トップページには先ほど変更した内容の投稿が存在することを確認する（テキスト）
      expect(page).to have_content("#{@post1.text}+編集したテキスト")
    end
  end
  context '投稿編集ができないとき' do
    it 'ログインしたユーザーは自分以外の投稿の編集画面には遷移できない' do
      # 投稿1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'user_email', with: @post1.user.email
      fill_in 'user_password', with: @post1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 投稿2に「編集」ボタンがないことを確認する
      expect(
        all(".post-index")[0]
      ).to  have_no_content('編集')
    end
    it 'ログインしていないと投稿の編集画面には遷移できない' do
      # トップページにいる
      visit root_path
      # 投稿1に「編集」ボタンがないことを確認する
      expect(
        all(".post-index")[1]
      ).to  have_no_content('編集')
      # 投稿2に「編集」ボタンがないことを確認する
      expect(
        all(".post-index")[0]
      ).to  have_no_content('編集')
    end
  end
end

RSpec.describe '投稿削除', type: :system do
  before do
    @post1 = FactoryBot.create(:post)
    @post2 = FactoryBot.create(:post)
  end
  context '投稿削除ができるとき' do
    it 'ログインしたユーザーは自らが投稿した投稿の削除ができる' do
      # 投稿1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'user_email', with: @post1.user.email
      fill_in 'user_password', with: @post1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 投稿1に「削除」ボタンがあることを確認する
      expect(
        all(".post-index")[1]
      ).to  have_content('削除')
      # 投稿を削除するとレコードの数が1減ることを確認する
      expect{
        all(".post-index")[1].hover.find_link('削除', href: post_path(@post1)).click
      }.to change { Post.count }.by(-1)
      # トップページに遷移する
      expect(current_path).to eq root_path
      # トップページには投稿1の内容が存在しないことを確認する
      expect(page).to have_no_content("#{@post1.text}")
    end
  end
  context '投稿削除ができないとき' do
    it "ログインしたユーザーは自分以外の投稿を削除できない" do
     # 投稿1を投稿したユーザーでログインする
     visit new_user_session_path
      fill_in 'user_email', with: @post1.user.email
      fill_in 'user_password', with: @post1.user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
     # 投稿2に「削除」ボタンが無いことを確認する
     expect(
      all(".post-index")[0]
    ).to  have_no_content('削除')
    end
    it "ログインしていないユーザーは削除が表示されない" do
       # トップページに移動する
       visit root_path
      # 投稿1に「削除」ボタンが無いことを確認する
      expect(
        all(".post-index")[1]
      ).to  have_no_content('削除')
      # 投稿2に「削除」ボタンが無いことを確認する
      expect(
        all(".post-index")[0]
      ).to  have_no_content('削除')
    end
  end
end

RSpec.describe '投稿詳細', type: :system do
  before do
    @post1 = FactoryBot.create(:post)
    @post2 = FactoryBot.create(:post)
  end
  it 'ログインしたユーザーは投稿詳細ページに遷移してコメント投稿欄が表示される' do
    # 投稿1を投稿したユーザーでログインする
    visit new_user_session_path
    fill_in 'user_email', with: @post1.user.email
    fill_in 'user_password', with: @post1.user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
    # 詳細ページに遷移する
    visit  post_path(@post1)
    # 詳細ページに投稿の内容が含まれている
    expect(page).to have_selector("img[src$='test_image.png']")
    expect(page).to have_content("#{@post1.text}")
    #編集と削除ボタンがあることを確認する
    expect(page).to have_content("編集")
    expect(page).to have_content("削除")
    # コメント用のフォームが存在する
    expect(page).to have_content("クリックしてファイルをアップロード")
  end
  it "ログインしたユーザーは自分の投稿でない投稿詳細ページに遷移しても編集と削除が出来ない。しかし、コメント投稿欄が表示される" do
    #投稿1を投稿したユーザーでログインする
    visit new_user_session_path
    fill_in 'user_email', with: @post1.user.email
    fill_in 'user_password', with: @post1.user.password
    find('input[name="commit"]').click
    expect(current_path).to eq root_path
    #投稿2の詳細ページに遷移する
    visit post_path(@post2)
    #詳細に投稿の内容が記載されている
    expect(page).to have_selector("img[src$='test_image.png']")
    expect(page).to have_content("#{@post2.text}")
    #編集と削除ボタンが存在しない
    expect(page).to have_no_content("編集")
    expect(page).to have_no_content("削除")
    #コメント用のフォームは存在する
    expect(page).to have_content("クリックしてファイルをアップロード")
  end
  it 'ログインしていない状態で投稿詳細ページに遷移できるものの、コメント投稿欄が表示されない' do
    # トップページに移動する
    visit root_path
    # 詳細ページに遷移する
    visit post_path(@post1)
    # 詳細ページに投稿の内容が含まれている
    expect(page).to have_selector("img[src$='test_image.png']")
    expect(page).to have_content("#{@post1.text}")
    # フォームが存在しないことを確認する
    expect(page).to have_no_content("クリックしてファイルをアップロード")
  end
end