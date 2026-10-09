class Bid < ApplicationRecord
  belongs_to :listing

  validates :bidder_name, presence: true
  validates :amount, numericality: { only_integer: true }
  validate :auction_open_and_amount_high_enough

  private

  def auction_open_and_amount_high_enough
    return unless listing
    unless listing.open?
      errors.add(:base, "Auction has ended")
      return
    end
    return if amount.blank? || !amount.is_a?(Integer)

    if amount < listing.minimum_next_bid
      errors.add(:amount, "must be at least €#{listing.minimum_next_bid}")
    end
  end
end
