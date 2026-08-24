class Setting < ApplicationRecord
  DISGUISES = %w[Calculator Weather Tile\ game Sports].freeze
  TIMER_STEPS = [ 0, 60, 1440, 10080 ].freeze
  AVATAR_COLORS = %w[#c29765 #a9bd7e #8a9a5b #d9b98a].freeze

  validates :text_scale, inclusion: { in: 16..22 }
  validates :disguise, inclusion: { in: DISGUISES }
  validates :pseudonym, length: { maximum: 40 }, allow_nil: true
  validates :avatar_color, inclusion: { in: AVATAR_COLORS }, allow_blank: true
  validates :disguise_accent, format: { with: /\A#[0-9a-fA-F]{6}\z/, message: "must be a hex colour" }, allow_blank: true

  after_initialize do
    self.disguise ||= "Weather"
    self.text_scale ||= 18
    self.avatar_color ||= "#c29765"
  end

  def self.instance
    first || create!(disguise: "Calculator")
  end

  def verify_pin(plain)
    BCrypt::Password.new(pin_digest) == plain.to_s
  rescue BCrypt::Errors::InvalidHash
    false
  end

  def pin=(plain)
    self.pin_digest = BCrypt::Password.create(plain)
  end

  def chat_timer_label
    case chat_timer_minutes
    when nil, 0 then "Off"
    when 60 then "1 hour"
    when 1440 then "24 hours"
    when 10080 then "7 days"
    end
  end

  def next_chat_timer
    idx = TIMER_STEPS.index(chat_timer_minutes || 0) || -1
    TIMER_STEPS[(idx + 1) % TIMER_STEPS.size]
  end

  def initial
    pseudonym.to_s.strip.first&.upcase || "?"
  end
end
