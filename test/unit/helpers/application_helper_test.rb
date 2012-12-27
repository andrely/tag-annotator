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
  def test_obt_downcase
    assert_equal("uNESCO", obt_downcase("UNESCO"))
  end

  def test_strip_quotes
    assert_equal('ba', strip_quotes('ba'))
    assert_equal('"ba', strip_quotes('"ba'))
    assert_equal('ba"', strip_quotes('ba"'))
    assert_equal('ba', strip_quotes('"ba"'))
    assert_equal('"', strip_quotes('"'))
  end
end