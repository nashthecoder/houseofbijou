class AddReviewedAtToPanicAlerts < ActiveRecord::Migration[8.1]
  def change
    add_column :panic_alerts, :reviewed_at, :datetime
  end
end
