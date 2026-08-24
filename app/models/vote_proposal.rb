class VoteProposal < ApplicationRecord
  validates :title, presence: true
end
