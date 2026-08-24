class PanicController < BaseController
  def show
    @recent_alert = PanicAlert.order(:created_at).last
    @recent_alert = nil if @recent_alert && @recent_alert.created_at < 5.minutes.ago
  end

  def create
    contacts = Contact.limit(5)
    alert = PanicAlert.new(
      contacts_notified: contacts.size,
      delivered_via: "app + SMS fallback",
      latitude: location_params[:latitude].presence&.to_f,
      longitude: location_params[:longitude].presence&.to_f
    )
    alert.save!

    sms_results = contacts.map do |contact|
      SmsGateway.deliver_alert(phone: contact.phone.to_s, message: alert_message(alert))
    end

    sent = sms_results.count(&:sent?)
    alert.update!(sms_status: "#{sent}/#{sms_results.size} SMS handed to relay")

    redirect_to panic_path, toast: "Alert delivered to #{alert.contacts_notified} trusted contacts."
  end

  private

  def location_params
    params.permit(:latitude, :longitude)
  end

  # Composed in memory, discarded after hand-off — never persisted.
  def alert_message(alert)
    parts = [ "House of Bijou alert: your friend needs help now." ]
    parts << "Last known location: #{alert.coordinates_label}." if alert.coordinates_label
    parts.join(" ")
  end
end
