class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :account, foreign_key: true, null: false
      t.references :post, foreign_key: true, null: false

      t.timestamps
      t.index [:account_id, :post_id], unique: true
    end
  end
end
