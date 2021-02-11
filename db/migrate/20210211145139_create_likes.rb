class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes, id: false do |t|
      t.references :account, foreign_key: true, null: false
      t.references :post, foreign_key: true, null: false

      t.timestamps
    end
  end
end
