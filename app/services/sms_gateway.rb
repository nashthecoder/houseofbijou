# Delivers panic-alert SMS through Africa's Talking.
#
# Without credentials configured (development / test), deliveries are logged and
# discarded immediately — nothing is retained, matching the blind-relay behaviour.
class SmsGateway
  AT_SMS_HOST = "api.africastalking.com".freeze
  AT_SMS_PATH = "/version1/messaging".freeze

  Result = Data.define(:status, :detail) do
    def sent? = status == :sent
  end

  class << self
    # Fire-and-forget: deliver + immediately discard. Returns a summary only.
    def deliver_alert(phone:, message:)
      return skipped unless configured?

      response = Net::HTTP.start(AT_SMS_HOST, use_ssl: true) do |http|
        http.post(AT_SMS_PATH, form_body(phone:, message:), headers)
      end
      status = response.code.to_i == 201 ? :sent : :failed
      Result.new(status:, detail: "africas-talking #{response.code}")
    rescue StandardError => e
      Rails.logger.error("[SmsGateway] delivery error: #{e.class}")
      Result.new(status: :failed, detail: "network error")
    end

    def configured?
      ENV["AT_API_KEY"].present? && ENV["AT_USERNAME"].present?
    end

    private

    def skipped
      Rails.logger.info("[SmsGateway] dev mode — alert SMS logged and discarded")
      Result.new(status: :skipped, detail: "dev relay")
    end

    def form_body(phone:, message:)
      URI.encode_www_form(
        username: ENV.fetch("AT_USERNAME"),
        to: phone,
        message: message,
        from: ENV["AT_SENDER_ID"].presence || "BIJOU"
      )
    end

    def headers
      {
        "apiKey" => ENV.fetch("AT_API_KEY"),
        "Content-Type" => "application/x-www-form-urlencoded",
        "Accept" => "application/json"
      }
    end
  end
end
