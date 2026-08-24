class AidRequest < ApplicationRecord
  has_many :pledges, dependent: :destroy

  validates :title, presence: true
  validates :target_amount, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[open met] }

  scope :open_first, -> { order(Arel.sql("CASE WHEN status = 'open' THEN 0 ELSE 1 END"), deadline: :asc) }

  def pledged_amount
    pledges.sum(:amount)
  end

  def progress_percent
    [ [ (pledged_amount.to_f / target_amount * 100).round, 100 ].min, 0 ].max
  end

  def deadline_label
    deadline.strftime("%b %-d")
  end

  def days_left
    (deadline - Date.current).to_i
  end
end
