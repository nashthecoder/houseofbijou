class Pledge < ApplicationRecord
  belongs_to :aid_request

  validates :helper_name, presence: true
  validates :amount, numericality: { greater_than: 0 }, allow_nil: true
  validates :kind, inclusion: { in: %w[pledge given] }
end
