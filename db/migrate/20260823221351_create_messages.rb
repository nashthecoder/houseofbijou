class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.string :sender
      t.text :body

      t.timestamps
    end
  end
end
