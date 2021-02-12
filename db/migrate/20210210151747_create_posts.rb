class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.text :description
      t.references :author, null: false, foreign_key: { to_table: :accounts }

      t.timestamps
    end
  end
end
