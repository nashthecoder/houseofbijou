class CreateSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :settings do |t|
      t.string :pin_digest
      t.integer :text_scale
      t.boolean :high_contrast
      t.string :disguise
      t.integer :chat_timer_minutes
      t.datetime :alerts_reviewed_at
      t.datetime :values_accepted_at

      t.timestamps
    end
  end
end
