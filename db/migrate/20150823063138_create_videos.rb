class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :category
      t.string :url
      t.text :image
      t.integer :view
      t.integer :comment
      t.integer :mylist

      t.timestamps null: false
    end
  end
end
