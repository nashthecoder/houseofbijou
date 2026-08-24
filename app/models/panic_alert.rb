class PanicAlert < ApplicationRecord
  validates :contacts_notified, numericality: { greater_than_or_equal_to: 0 }
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }, allow_nil: true
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, allow_nil: true

  def coordinates_label
    return nil if latitude.nil? || longitude.nil?

    format("%.4f, %.4f", latitude, longitude)
  end
end
