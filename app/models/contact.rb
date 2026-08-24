class Contact < ApplicationRecord
  validates :name, presence: true

  before_validation { self.color ||= "#c29765" }
end
