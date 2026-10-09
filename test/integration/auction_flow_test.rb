require "test_helper"

class AuctionFlowTest < ActionDispatch::IntegrationTest
  setup do
    @listing = Listing.create!(title: "Mercedes 190E", starting_price: 8_000, ends_at: 2.days.from_now)
  end

  test "viewing an auction records a view" do
    assert_difference "Event.where(kind: 'view').count", 1 do
      get listing_path(@listing)
    end
    assert_response :success
  end

  test "valid bid is saved and tracked" do
    assert_difference ["Bid.count", "Event.where(kind: 'bid_attempt').count", "Event.where(kind: 'bid_success').count"], 1 do
      post listing_bids_path(@listing), params: { bid: { bidder_name: "Alice", amount: 8_000 } }
    end
    assert_redirected_to listing_path(@listing)
  end

  test "low bid fails but attempt is counted" do
    assert_no_difference "Bid.count" do
      assert_difference "Event.where(kind: 'bid_attempt').count", 1 do
        assert_no_difference "Event.where(kind: 'bid_success').count" do
          post listing_bids_path(@listing), params: { bid: { bidder_name: "Alice", amount: 7_999 } }
        end
      end
    end
    assert_response :unprocessable_entity
    assert_select ".errors", /at least/
  end

  test "stats shows conversion from one success and two views" do
    2.times { get listing_path(@listing) }
    post listing_bids_path(@listing), params: { bid: { bidder_name: "Alice", amount: 8_000 } }
    get stats_path
    assert_response :success
    assert_select "tr", text: /Mercedes 190E.*2.*1.*1.*50.0%/m
  end
end
