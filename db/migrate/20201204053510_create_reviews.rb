class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true
      t.text :text
      t.integer :rating
      t.timestamps
    end
  end
end
