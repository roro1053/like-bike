require 'rails_helper'

RSpec.describe "ユーザー新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ユーザー登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      fill_in 'user_password_confirmation', with: @user.password_confirmation
      fill_in 'user_nickname', with: @user.nickname
      fill_in 'user_profile', with: @user.profile
      #fill_in 'user_image', with: @user.image
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect{ 
        find('input[name="commit"]').click 
      }.to change { User.count }.by(1)
      # トップページへ遷移する
      expect(current_path).to eq root_path
      # ログインするとログアウトボタンが表示されることを確認する
      expect(page).to have_content('ログアウト')
      expect(page).to have_content('新規投稿')
      expect(page).to have_content('アイテムを投稿')
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('ユーザー登録')
      expect(page).to have_no_content('ゲストログイン')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ユーザー登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user_email', with: ""
      fill_in 'user_password', with: ""
      fill_in 'user_password_confirmation', with: ""
      fill_in 'user_nickname', with: ""
      fill_in 'user_profile', with: ""
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq "/users"
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # 新規登録、アイテムを投稿、ログアウトボタンが表示されることを確認する
      expect(page).to have_content('ログアウト')
      expect(page).to have_content('新規投稿')
      expect(page).to have_content('アイテムを投稿')
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('ユーザー登録')
      expect(page).to have_no_content('ゲストログイン')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ログインができないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'user_email', with: ""
      fill_in 'user_password', with: ""
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq new_user_session_path
    end
  end
end
RSpec.describe "ユーザー編集", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ユーザー情報を変更できる時' do
    it 'ログインしたユーザーはユーザー編集ができる' do
      #ログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      find('input[name="commit"]').click
      #「プロフィールを変更する」ボタンが存在することを確認する
      expect(page).to have_content('プロフィールを編集')
      #プロフィール変更ページに遷移する
      visit edit_user_registration_path
       #ユーザー登録時に入力した情報が存在することを確認する
      expect(
        find('#user_nickname').value
      ).to eq @user.nickname
      expect(
        find('#user_profile').value
      ).to eq @user.profile
      #ユーザーネームとプロフィールを編集する
      fill_in 'user_current_password', with: @user.password
      fill_in 'user_nickname', with: "#{@user.nickname}+編集したニックネーム"
      fill_in 'user_profile', with: "#{@user.profile}+編集したプロフィール"
      attach_file "user_image", "public/images/test_image2.png"
       #プロフィールを更新してもUserモデルのレコードの数が変わらないことを確認する
      expect{
        click_button('プロフィールを更新する')
      }.to change { User.count }.by(0)
      #トップページに遷移することを確認する
      expect(current_path).to eq root_path
      #ユーザー情報が変更されていることを確認する（nickname,image）
      expect(page).to have_content("#{@user.nickname}+編集したニックネーム")
      expect(page).to have_selector("img[src$='test_image2.png']")
      # ユーザー情報が変更されていることを確認する(profile)
      visit edit_user_registration_path
      expect(page).to have_content("#{@user.profile}+編集したプロフィール")
    end
    it 'パスワードを変更する' do
      # ログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      find('input[name="commit"]').click
      # 「プロフィールを変更する」ボタンが存在することを確認する
      expect(page).to have_content('プロフィールを編集')
      # プロフィール変更ページに遷移する
      visit edit_user_registration_path
      # ユーザー登録時に入力した情報が存在することを確認する
       expect(
        find('#user_nickname').value
      ).to eq @user.nickname
      expect(
        find('#user_profile').value
      ).to eq @user.profile
      # パスワードを変更する
      fill_in 'user_password', with: "00000p"
      fill_in 'user_password_confirmation', with: "00000p"
      fill_in 'user_current_password', with: @user.password
      # プロフィールを更新してもUserモデルのレコードの数が変わらないことを確認する
      expect{
        click_button('プロフィールを更新する')
      }.to change { User.count }.by(0)
      # トップページに遷移することを確認する
      expect(current_path).to eq root_path
      # プロフィール変更ページに遷移する
      visit edit_user_registration_path
      # 変更する前のパスワードを入力する
      fill_in 'user_current_password', with: @user.password
      # プロフィールを更新してもUserモデルのレコードの数が変わらないことを確認する
      expect{
        click_button('プロフィールを更新する')
      }.to change { User.count }.by(0)
      # 編集ページに留まることを確認する
      expect(current_path).to eq "/users"
      # エラーメッセージが出ることを確認する
      expect(page).to have_content("Current password translation missing:")
    end
  context 'ユーザー情報を変更できない時' do
    it '誤った情報では更新ができずに、編集ページにとどまる' do
      # ログインする
      visit new_user_session_path
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      find('input[name="commit"]').click
      # 「プロフィールを変更する」ボタンが存在することを確認する
      expect(page).to have_content('プロフィールを編集')
      # プロフィール変更ページに遷移する
      visit edit_user_registration_path
      # ユーザー登録時に入力した情報が存在することを確認する
      expect(
        find('#user_nickname').value
      ).to eq @user.nickname
      expect(
        find('#user_profile').value
      ).to eq @user.profile
      # ユーザーネームとプロフィールを編集する
      fill_in 'user_current_password', with: ""
      # プロフィールを更新してもUserモデルのレコードの数が変わらないことを確認する
      expect{
        click_button('プロフィールを更新する')
      }.to change { User.count }.by(0)
      # 編集ページに留まることを確認する
      expect(current_path).to eq "/users"
      # エラーメッセージが出ることを確認する
      expect(page).to have_content("Current password translation missing:")
      end
      it 'ログインしていないとユーザー編集ボタンが表示されない' do
      # トップページに移動する
      visit root_path
      # ユーザー編集ボタンが表示されない
      expect(page).to have_no_content("プロフィール編集")
      end
    end
  end
end