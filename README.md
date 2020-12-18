### 「like-bike」

___

「自転車が欲しいけど、どうやって選べばいいかわからない」

「サイクリングのモチベーションが上がらない」

like-bikeはこれから自転車を始める人の助けとなり、自転車好きの仲間を繋ぐSNSアプリケーションです。

___

# URL http://13.112.128.186/

Basic認証を導入しております。

username: admin

password: 2073

簡単ログイン機能を実装しております。動作のご確認はゲストアカウントを利用してくださると幸いです。
___

# アプリケーションを作った理由

以下の二点を解決したいと考え制作しました。

* 「自転車の購入を考えている人のミスマッチを防ぐ」
* 「モチベーションが上がらない」

コロナの影響により、電車やバスなどの移動を避ける為に、テレワークや活動自粛による運動不足を解消する為に、自転車が注目を集めています。

しかし、その性能や価格はピンからキリまで存在し、選択肢が多い為に選ぶのが難しくなっています。

また、自転車を使う人も「モチベーションが上がらない」という問題を抱えています。

___


# 利用方法

![demo03](https://user-images.githubusercontent.com/72964932/102595686-5e02c000-415b-11eb-9be1-e575c6c4519c.jpg)


* トップページから「投稿一覧」と「アイテム一覧」があります。こちらでユーザーが投稿された呟きや、アイテムを閲覧することが可能です。  
  
* 投稿に対しては「コメント」を、アイテムに対しては「レビュー」を行うことができます。

* 検索では投稿やアイテムを検索することができます。

* アイテムはレビュー評価が表示され、評価の高いアイテムが一目で分かり、購入するかの一定の指標になります。
___
# 洗い出した要件

* ユーザー管理機能(devise gem)

* 簡単ログイン機能

* 新規投稿機能

* 投稿一覧

* 投稿詳細表示機能

* 投稿編集機能

* 投稿削除機能

* 投稿検索機能

* いいね機能（Ajax）

* コメント機能

* コメント削除機能

* アイテム投稿機能

* アイテム一覧機能

* アイテム詳細表示機能

* アイテム削除機能

* アイテム検索機能

* タグ付機能

* レビュー機能

* レビュー削除機能

* マイページ
___
# 実装予定の機能

* カレンダー機能

* フォロー機能

* 走行距離計測機能

* googlemapとの連携

___

# データベース設計

<img width="1143" alt="ER02" src="https://user-images.githubusercontent.com/72964932/102610845-3880b100-4171-11eb-86e7-d7cc8794739a.png">

___

# テーブル設計

## usersテーブル

|Column|Type|Options|
|------|----|-------|
| email | string | null: false |
| nickname | string | null: false |
| profile | text | |
| image | string | |
| encrypted_password | string | null: false |

### Association
- has_many :posts
- has_many :comments
- has_many :items
- has_many :reviews
- has_many :likes

## postsテーブル
|Column|Type|Options|
|------|----|-------|
| text | text | |
| image | string | |
| likes_count | integer | |
| user_id | references | foreign_key: true |

### Association
- belongs_to :user
- has_many :comments
- has_many :likes

## commentsテーブル
|Column|Type|Options|
|------|----|-------|
| user_id | integer | |
| post_id | integer | |
| text | text | |
| image | string |  | 

### Association
- belongs_to :user
- belongs_to :post

## itemsテーブル
|Column|Type|Options|
|------|----|-------|
| name | string | null: false |
| text | text | null: false |
| user_id | references | foreign_key: true |
| image | string | |

### Association
- belongs_to :user
- has_many :item_tag_relations
- has_many :tags
- has_many :reviews
  

## likesテーブル
|Column|Type|Options|
|------|----|-------|
| user_id | integer | |
| post_id | integer | |

### Association
- belongs_to :user
- belongs_to :post

## reviewsテーブル
|Column|Type|Options|
|------|----|-------|
| user_id | references | foreign_key: true |
| item_id | references | foreign_key: true |
| text | text| null: false |
| rating | integer | null: false |

### Association
- belongs_to :user
- belongs_to :item

## item_tag_relationsテーブル
|Column|Type|Options|
|------|----|-------|
| item_id | references | foreign_key: true |
| tag_id | references | foreign_key: true |

### Association
- belongs_to :item
- belongs_to :tag

## tagsテーブル
|Column|Type|Options|
|------|----|-------|
| word | string | |

### Association
- has_many :item_tag_relations
- has_many :items
___

# 使用言語・環境
【フロントエンド】
 * HTML
 * CSS
 * Javascript

 【バックエンド】
* Ruby 2.6.5
* Rails 6.0.3.4

【データベース】

* MySQL 5.6.47 

【本番環境】

* AWS(S3・EC2)
* Nginx
* Unicorn

【その他使用技術】

* Git・GitHub
* RSpec
* Rubocop
* Capistrano