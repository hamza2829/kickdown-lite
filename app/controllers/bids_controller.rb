class BidsController < ApplicationController
  def create
    @listing = Listing.find(params[:listing_id])
    @listing.events.create!(kind: "bid_attempt")
    @bid = @listing.bids.build(bid_params)

    # Recheck all bid rules while holding the listing's database lock.
    saved = @listing.with_lock do
      if @bid.save
        @listing.events.create!(kind: "bid_success")
        true
      else
        false
      end
    end

    if saved
      redirect_to @listing, notice: "Bid placed successfully."
    else
      @bids = @listing.bids.order(amount: :desc).to_a.reject(&:new_record?)
      render "listings/show", status: :unprocessable_entity
    end
  end

  private

  def bid_params
    params.require(:bid).permit(:bidder_name, :amount)
  end
end
