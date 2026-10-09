class ListingsController < ApplicationController
  before_action :set_listing, only: :show

  def index
    @listings = Listing.order(ends_at: :asc)
  end

  def show
    @listing.events.create!(kind: "view")
    @bid = @listing.bids.build
    load_bids
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = Listing.new(listing_params)
    if @listing.save
      redirect_to @listing, notice: "Auction created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:title, :description, :starting_price, :ends_at)
  end

  def load_bids
    @bids = @listing.bids.order(amount: :desc).to_a.reject(&:new_record?)
  end
end
