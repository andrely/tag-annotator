##
# This class parses tagged text files in the VRT format
#
# Currently works with TreeTagger output texts
#
class VRTReader
  # regex recognizing valid VRT line entries
  @@line_re = Regexp.new("^[^\t]+\t[^\t]+(\t[^\t]+)?")
  @@end_tags = ['SENT', 'FE']
  # extra sentence breaks for speech transcriptions
  @@end_strings = ['(.)', '(..)']

  @@max_sent_length = 30

  # any trailing data after the last valid entry will be stored
  # in this instance variable, an Array with the actual lines
  attr_accessor :postamble

  ##
  # Initialize with readable tagged text source
  def initialize(readable)
    @file = readable
    @postamble = nil
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

      if sent_index >= @@max_sent_length
        word.end_of_sentence_p = true
      end

      break if word.end_of_sentence_p
    end

    return nil if sentence.words.empty?

    return sentence
  end

  ##
  # Parse the next word line in the readable
  def get_next_word(file, preamble = [])
    begin
      line = file.readline.strip
    rescue EOFError
      # save any trailing data
      @postamble = preamble.join("\n") if preamble.count > 0

      return nil
    end

    # process normally if this is a line with a valid entry
    if @@line_re.match(line)
      word, tag, lemma = line.split

      w = Word.new
      w.string = word

      t = Tag.new
      t.string = tag
      t.lemma = lemma
      w.tags << t

      if @@end_tags.member?(tag) or
          @@end_strings.member?(w.string)
        w.end_of_sentence_p = true
      end

      if preamble.count > 0
        w.preamble = preamble.join("\n")
      end

      return w
    else
      # if the line is not valid, keep it as preamble data and parse
      # parse the next line
      preamble << [line]

      return get_next_word(file, preamble)
    end
  end

  ##
  # Parse VRT format tagged text from the string
  # TODO handle encoding
  def self.stringToText(str, encoding = 'utf-8')
    StringIO.new(str) do |f|
      return VRTReader.readableToText(f)
    end
  end

  ##
  # Parse VRT format tagged text from the given filename
  # TODO handle encoding
  def self.fileToText(file, encoding = 'utf-8')
    File.open(file, 'r') do |f|
      return VRTReader.readableToText(f)
    end
  end

  def self.readableToText(readable)
    text = TaggedText.new
    iterator = VRTReader.new(readable)
    iterator.each_sentence { |s| text.sentences << s}
    text.save

    if iterator.postamble
      text.postamble = iterator.postamble
    end

    return text
  end

  ##
  # Generate a VRT text format output string for the given TaggedText instance
  def self.textToString(text)
    str = ''

    text.sentences.each do |s|
      s.words.each do |w|
        str += w.preamble + "\n" if w.preamble
        str += "#{w.string}\t#{w.tags[0].string}\t#{w.tags[0].lemma}\n"
      end
    end

    str += text.postamble + "\n" if text.postamble

    return str
  end
end