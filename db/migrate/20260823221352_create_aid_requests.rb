class CreateAidRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :aid_requests do |t|
      t.string :title
      t.integer :target_amount
      t.date :deadline
      t.string :status

      t.timestamps
    end
  end
end
