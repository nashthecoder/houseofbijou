class CreatePanicAlerts < ActiveRecord::Migration[8.1]
  def change
    create_table :panic_alerts do |t|
      t.integer :contacts_notified
      t.string :delivered_via

      t.timestamps
    end
  end
end
