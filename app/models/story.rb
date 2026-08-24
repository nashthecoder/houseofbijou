class Story < ApplicationRecord
  VISIBILITIES = %w[circle].freeze

  validates :author, presence: true
  validates :body, presence: true
  validates :visibility, inclusion: { in: VISIBILITIES }
end
