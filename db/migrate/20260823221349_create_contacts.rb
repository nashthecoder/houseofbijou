class CreateContacts < ActiveRecord::Migration[8.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :color
      t.string :relationship
      t.integer :position

      t.timestamps
    end
  end
end
