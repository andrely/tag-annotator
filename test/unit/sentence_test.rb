require 'test_helper'

class SentenceTest < ActiveSupport::TestCase
  def setup
    fn = File.join(TEST_DATA_PATH, "obno_sent_boundary_1.cor")
    iterator = OBNOTextIterator.new(File.open(fn))
    @text = TaggedText.new
    @text.title = "fixture text"
    iterator.each_sentence { |s| @text.sentences << s}

    @text.save

    @s_id = Sentence.find_by_text_index(0).id
  end

  def teardown
    @text.destroy
  end

  def test_add_word
    assert_not_nil(@text)

    s = Sentence.find(@s_id)
    assert_equal(2, s.length)
    w = s.words[0]
    s.add_word(w.id, {:string => 'foo', :orig_string => 'foo'})
    assert_equal(3, s.length)
    s.save

    s = Sentence.find(@s_id)
    assert_equal(3, s.length)

    assert_equal('foo', s.words[1].string)

    w = s.words[0]
    s.add_word(w.id, {:string => 'bar', :orig_string => 'Bar'}, :position => :before)
    assert_equal(4, s.length)
    s.save

    s = Sentence.find(@s_id)
    assert_equal(4, s.length)

    assert_equal('bar', s.words[0].string)
  end

  def test_delete_word
    assert_not_nil(@text)

    s = Sentence.find(@s_id)
    assert_equal(2, s.length)

    w = s.words[0]
    s.delete_word(w.id)
    assert_equal(1, s.length)
    s.save

    Sentence.find(@s_id)
    assert_equal(1, s.length)
  end
end
