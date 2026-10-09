ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
class ActiveSupport::TestCase
  # Tests create their own records; no fixtures are used.
end
