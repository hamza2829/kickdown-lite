[
  ["Mercedes-Benz 190E", "A timeless 1980s German sports sedan.", 12_000],
  ["Porsche 911", "Classic rear-engined sports car.", 45_000],
  ["BMW E30", "Iconic compact BMW from the 1980s.", 15_000]
].each do |title, description, price|
  Listing.find_or_create_by!(title: title) do |listing|
    listing.description = description
    listing.starting_price = price
    listing.ends_at = 5.days.from_now
  end
end
