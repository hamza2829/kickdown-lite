class Event < ApplicationRecord
  KINDS = %w[view bid_attempt bid_success].freeze

  belongs_to :listing
  validates :kind, inclusion: { in: KINDS }
end
