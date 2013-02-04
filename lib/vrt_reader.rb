##
# This class parses tagged text files in the VRT format
#
# Currently works with TreeTagger output texts
#
class VRTReader
  ##
  # Initialize with readable tagged text source
  def initialize(readable)
    @file = readable
  end

  ##
  # Iterator yielding the next sentence in the text source
  def each_sentence
    text_index = 0

    while sentence = get_next_sentence(@file)
      sentence.text_index = text_index
      text_index += 1

      yield sentence
    end
  end

  ##
  # Parse the next sentence in the given readable
  def get_next_sentence(file)
    sentence = Sentence.new
    sent_index = 0

    while true
      word = get_next_word(file)
      break if word.nil?

      word.sentence_index = sent_index
      word.tag_count = word.tags.count
      sentence.words << word

      sent_index += 1

      break if word.end_of_sentence_p
    end

    return nil if sentence.words.empty?

    return sentence
  end

  ##
  # Parse the next word line in the readable
  def get_next_word(file)
    begin
      line = file.readline
    rescue EOFError
      return nil
    end
    word, tag, lemma = line.split

    w = Word.new
    w.string = word

    t = Tag.new
    t.string = tag
    t.lemma = lemma
    w.tags << t

    if tag == 'SENT'
      w.end_of_sentence_p = true
    end

    return w
  end

  ##
  # Generate a VRT text format output string for the given TaggedText instance
  def self.textString(text)
    str = ''

    text.sentences.each do |s|
      s.words.each do |w|
        str += "#{w.string}\t#{w.tags[0].string}\t#{w.tags[0].lemma}\n"
      end
    end

    return str
  end
end