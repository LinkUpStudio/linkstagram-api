class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :message
      t.references :post, foreign_key: true, null: false
      t.references :commenter, foreign_key: { to_table: :accounts }, null: false

      t.timestamps
    end
  end
end
