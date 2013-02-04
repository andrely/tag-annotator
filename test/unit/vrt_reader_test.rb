require "test/test_helper"

require "lib/vrt_reader"

class VRTReaderTest < Test::Unit::TestCase
  def test_tt_simple
    fn = File.join(TEST_DATA_PATH, 'tt_simple_1')

    text = TaggedText.new
    iterator = VRTReader.new(File.open(fn))
    iterator.each_sentence { |s| text.sentences << s}
    text.save

    assert_equal(2, text.sentences.count)
    assert_equal(5, text.sentences[0].length)
    assert_equal(3, text.sentences[1].length)

    out = VRTReader.textString(text)
    out.tr_s("\t ", ' ').strip!
    out_file = File.open(fn).read
    out_file.tr_s("\t ", ' ').strip!

    assert_equal(out_file, out)
  end
end
