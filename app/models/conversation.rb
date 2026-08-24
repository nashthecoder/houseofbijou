class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy

  validates :title, presence: true

  scope :ordered, -> { order(:position, :id) }

  def last_message
    messages.last
  end

  def initial
    title.first.upcase
  end
end
