class CreatePledges < ActiveRecord::Migration[8.1]
  def change
    create_table :pledges do |t|
      t.references :aid_request, null: false, foreign_key: true
      t.string :helper_name
      t.integer :amount
      t.string :note
      t.string :kind

      t.timestamps
    end
  end
end
