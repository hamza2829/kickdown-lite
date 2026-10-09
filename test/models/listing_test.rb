require "test_helper"

class ListingTest < ActiveSupport::TestCase
  setup do
    @listing = Listing.create!(title: "BMW E30", starting_price: 10_000, ends_at: 2.days.from_now)
  end

  test "requires title and positive whole euro price" do
    @listing.title = ""
    @listing.starting_price = -1
    assert_not @listing.valid?
    assert @listing.errors[:title].any?
    assert @listing.errors[:starting_price].any?
  end

  test "requires future end date on create" do
    assert_not Listing.new(title: "Old car", starting_price: 100, ends_at: 1.minute.ago).valid?
    assert_not Listing.new(title: "Old car", starting_price: 100).valid?
  end

  test "current price and minimum next bid" do
    assert_equal 10_000, @listing.current_price
    assert_equal 10_000, @listing.minimum_next_bid
    @listing.bids.create!(bidder_name: "Alice", amount: 10_000)
    assert_equal 10_000, @listing.current_price
    assert_equal 10_050, @listing.minimum_next_bid
    @listing.bids.create!(bidder_name: "Bob", amount: 10_100)
    assert_equal 10_100, @listing.current_price
    assert_equal 10_150, @listing.minimum_next_bid
  end
end
