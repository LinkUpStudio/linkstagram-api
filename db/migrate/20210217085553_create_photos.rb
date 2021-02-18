class CreatePhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :photos do |t|
      t.jsonb :image_data, null: false
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
