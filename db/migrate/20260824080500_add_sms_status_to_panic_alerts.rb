class AddSmsStatusToPanicAlerts < ActiveRecord::Migration[8.1]
  def change
    add_column :panic_alerts, :sms_status, :string
  end
end
