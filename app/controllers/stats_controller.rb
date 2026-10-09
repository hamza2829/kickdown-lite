class StatsController < ApplicationController
  def index
    @listings = Listing.order(:id)
    @counts = Event.group(:listing_id, :kind).count
  end
end
