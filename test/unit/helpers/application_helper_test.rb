require "test/unit"

class ApplicationHelperTest < Test::Unit::TestCase
  include ApplicationHelper

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  def test_fail
    assert_equal("uNESCO", obt_downcase("UNESCO"))
  end
end