class Message < ApplicationRecord
  belongs_to :conversation

  validates :sender, inclusion: { in: %w[them you] }
  validates :body, presence: true

  default_scope { order(:created_at, :id) }
  scope :alive, -> { where(expires_at: nil).or(where(expires_at: Time.current..)) }
  scope :expired, -> { where(expires_at: ...Time.current) }

  def expired?
    expires_at.present? && expires_at.past?
  end
end
