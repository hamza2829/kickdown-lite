require "test_helper"

class BidTest < ActiveSupport::TestCase
  setup do
    @listing = Listing.create!(title: "Porsche 911", starting_price: 20_000, ends_at: 2.days.from_now)
  end

  test "first bid must reach starting price" do
    assert_not @listing.bids.build(bidder_name: "Alice", amount: 19_999).valid?
    assert @listing.bids.build(bidder_name: "Alice", amount: 20_000).valid?
  end

  test "later bids must add at least fifty euros" do
    @listing.bids.create!(bidder_name: "Alice", amount: 20_000)
    assert_not @listing.bids.build(bidder_name: "Bob", amount: 20_049).valid?
    assert @listing.bids.build(bidder_name: "Bob", amount: 20_050).valid?
  end

  test "bids cannot be placed after end" do
    @listing.update_column(:ends_at, 1.minute.ago)
    bid = @listing.bids.build(bidder_name: "Alice", amount: 20_000)
    assert_not bid.valid?
    assert_includes bid.errors.full_messages.join, "Auction has ended"
  end

  test "bidder name is required" do
    assert_not @listing.bids.build(bidder_name: "", amount: 20_000).valid?
  end
end
