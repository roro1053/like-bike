require 'rails_helper'

def basic_pass(path)
  username = ENV['BASIC_AUTH_USER']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe PostsController, type: :request do
  before do
    @post = FactoryBot.create(:post)
  end
  describe 'GET /index' do
    it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
      get root_path
      expect(response.status).to eq 200
    end
    it 'indexアクションにリクエストすると投稿済のtextが存在する' do
      get root_path
      expect(response.body).to include @post.text
    end
    it 'indexアクションにリクエストすると投稿済の画像のURLが存在する' do
      get root_path

      expect(response.body).to include 'test_image.png'
    end
    it 'indexアクションにリクエストするとレスポンスに検索フォームが存在する' do
      get root_path
      expect(response.body).to include '投稿を検索する'
    end
    it 'indexアクションにリクエストするとゲストログインのボタンが存在する' do
      get root_path
      expect(response.body).to include 'ゲストログイン'
    end
    it 'indexアクションにリクエストするとユーザー登録ボタンが存在する' do
      get root_path
      expect(response.body).to include 'ユーザー登録'
    end
    it 'indexアクションにリクエストすると上に戻るボタンが存在する' do
      get root_path
      expect(response.body).to include '上に戻る'
    end
    describe 'GET #show' do
      it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
        get post_path(@post)
        expect(response.status).to eq 200
      end
      it 'showアクションにリクエストするとレスポンスに投稿済みのツイートのテキストが存在する' do
        get post_path(@post)
        expect(response.body).to include @post.text
      end
      it 'showアクションにリクエストするとレスポンスに投稿済みのツイートの画像URLが存在する' do
        get post_path(@post)
        expect(response.body).to include 'test_image.png'
      end
      it 'showアクションにリクエストするとレスポンスにコメント一覧表示部分が存在する' do
        get post_path(@post)
        expect(response.body).to include 'コメント一覧'
      end
    end
  end
end
