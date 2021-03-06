require "test/test_helper"

require "lib/vrt_reader"

class VRTReaderTest < Test::Unit::TestCase
  def test_tt_simple
    fn = File.join(TEST_DATA_PATH, 'tt_simple_1')
    text = VRTReader.fileToText(fn)

    assert_equal(2, text.sentences.count)
    assert_equal(5, text.sentences[0].length)
    assert_equal(3, text.sentences[1].length)

    out = VRTReader.textToString(text)
    out = out.tr_s("\t ", ' ').strip!
    out_file = File.open(fn).read
    out_file = out_file.tr_s("\t ", ' ').strip!

    assert_equal(out_file, out)
  end

  def test_tt_sgml
    fn = File.join(TEST_DATA_PATH, 'tt_sgml_1')
    text = VRTReader.fileToText(fn)

    assert_equal(2, text.sentences.count)
    assert_equal(5, text.sentences[0].length)
    assert_equal(3, text.sentences[1].length)

    out = VRTReader.textToString(text)
    out = out.tr_s("\t ", ' ').strip
    out_file = File.open(fn).read
    out_file = out_file.tr_s("\t ", ' ').strip

    assert_equal(out_file, out)
  end
end
