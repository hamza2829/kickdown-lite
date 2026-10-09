class Listing < ApplicationRecord
  MIN_INCREMENT = 50

  has_many :bids, dependent: :destroy
  has_many :events, dependent: :destroy

  validates :title, presence: true
  validates :starting_price, numericality: { only_integer: true, greater_than: 0 }
  validates :ends_at, presence: true
  validate :ends_in_future, on: :create

  def open?
    ends_at.present? && ends_at > Time.current
  end

  def highest_bid
    bids.order(amount: :desc, id: :asc).first
  end

  def current_price
    highest_bid&.amount || starting_price
  end

  def minimum_next_bid
    highest_bid ? highest_bid.amount + MIN_INCREMENT : starting_price
  end

  private

  def ends_in_future
    errors.add(:ends_at, "must be in the future") if ends_at.present? && ends_at <= Time.current
  end
end
