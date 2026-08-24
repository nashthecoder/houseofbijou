class AddLocationToPanicAlerts < ActiveRecord::Migration[8.1]
  def change
    add_column :panic_alerts, :latitude, :decimal, precision: 10, scale: 6
    add_column :panic_alerts, :longitude, :decimal, precision: 10, scale: 6
  end
end
