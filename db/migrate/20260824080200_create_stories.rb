class CreateStories < ActiveRecord::Migration[8.1]
  def change
    create_table :stories do |t|
      t.string :author, null: false
      t.text :body, null: false
      t.string :visibility, null: false, default: "circle"

      t.timestamps
    end
  end
end
