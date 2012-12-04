require "test/test_helper"

require "lib/obno_text_iterator"
require "lib/obno_text"

class OBNOTextIteratorTest < Test::Unit::TestCase

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

  def test_sentence_boundary
    fn = File.join(TEST_DATA_PATH, "obno_sent_boundary_1.cor")
    iterator = OBNOTextIterator.new(File.open(fn))
    text = TaggedText.new
    iterator.each_sentence { |s| text.sentences << s}

    text.save

    assert_equal(6, text.sentences.count)
    assert_equal(2, text.sentences[0].length)
    assert_equal(1, text.sentences[1].length)
    assert_equal(2, text.sentences[2].length)
    assert_equal(8, text.sentences[3].length)
    assert_equal(8, text.sentences[3].length)
    assert_equal(9, text.sentences[4].length)
    assert_equal(9, text.sentences[5].length)

    out = OBNOText.textString(text)
    out.tr_s!("\t ", ' ').strip!
    out_fn = File.join(TEST_DATA_PATH, "obno_sent_boundary_1_out.cor")
    out_file = File.open(out_fn).read
    out_file.tr_s!("\t ", ' ').strip!

    assert_equal(out_file, out)
  end
end