# Kickdown Lite

A small Ruby on Rails classic-car auction demo. Visitors can create listings, view auctions, and bid using a name. Each listing has a start price and an end time. The app tracks auction views, bid attempts, and successful bids, and shows a conversion table at `/stats`.

## Setup

Prerequisites: Ruby compatible with Rails 8.1, Bundler, SQLite development libraries, and internet access for the first gem install.

```bash
bundle install
bin/rails db:migrate db:seed
RAILS_ENV=test bin/rails db:migrate
bin/rails test
bin/rails server
```

Open http://localhost:3000. Seed data contains Mercedes 190E, Porsche 911, and BMW E30; their auctions end five days after seeding.

If starting completely from scratch, the usual generator command is `rails new kickdown-lite --database=sqlite3 --skip-javascript` (Rails defaults to Minitest). This archive contains the project source prepared directly because Rails could not be installed in the build environment.

## Design notes

- **Models own the rules:** Listing decides whether it is open and the minimum bid; Bid checks the bidder name, auction status, and amount.
- **Whole euros:** integer columns avoid floating-point rounding problems. No cents.
- **Concurrency:** `listing.with_lock` wraps bid validation, insertion, and success event. SQLite serializes writes, though under contention it can also raise `SQLite3::BusyException`; a production application should use PostgreSQL and add retry/error handling.
- **No login on purpose:** names are typed into the bid form to keep the exercise focused on Rails basics. This is not suitable for real-money auctions.
- **Funnel:** the stats page uses a single grouped aggregation: `Event.group(:listing_id, :kind).count`. Conversion is successful bids / views × 100; if there are no views, it displays 0%.
- **Show-page views:** a successful GET to the listing show action creates a view event. A rejected bid renders the show template without creating an extra view event.

## Next steps

Add authentication, background jobs to close auctions and notify winners, and Active Storage image uploads. For production, also add bid-lock contention retries, abuse protection, and stronger database constraints.

## Verified build status

On October 9, 2026, the project was run on Windows with Ruby 3.4.11 and Rails 8.1.4. Development and test database migrations completed, seeds loaded, and Minitest passed: 11 tests, 41 assertions, 0 failures, 0 errors. Puma served `/` and `/stats` with HTTP 200. The test database migration command above is required for a fresh checkout.

On Windows PowerShell, invoke Rails as `ruby bin/rails` and set the test environment with `$env:RAILS_ENV = "test"` before migrating the test database. Remove it with `Remove-Item Env:RAILS_ENV` before starting the development server.
