class OBNOTextIterator
  attr_reader :file, :postamble

  @peeked_word_record = nil
  @peeked_orig_word_record = nil
  @peeked_preamble = nil
  @postamble

  def initialize(readable, use_static_punctuation = false)
    @file = readable

    @word_regex = Regexp.compile('\"<(.*)>\"')
    @tag_regex = Regexp.compile('^;?\s+\"(.*)\"\s+([^\!]*?)\s*(<\*>\s*)?(<\*\w+>)?(<Correct\!>)?\s*(SELECT\:\d+\s*)*$')
    @punctuation_regex = Regexp.compile('^\$?[\.\:\|\?\!]$') # .:|!?
    @orig_word_regex = Regexp.compile('^<word>(.*)</word>$')

    @use_static_punctuation = use_static_punctuation
  end

  def each_sentence
    # File.open(@file) do |f|
      # @peeked_word_record, @peeked_orig_word_record, @peeked_preamble = get_word_header(f)

    text_index = 0

    while sentence = get_next_sentence(@file)
      sentence.text_index = text_index
      text_index += 1

      yield sentence
    end
    # end
  end

  def get_next_sentence(f)
    sentence = Sentence.new
    sent_index = 0

    begin
      while word = get_next_word(f)
        word.sentence_index = sent_index
        word.tag_count = word.tags.count
        sentence.words << word

        sent_index += 1

        break if word.is_punctuation? and @use_static_punctuation
        break if word.end_of_sentence_p and not @use_static_punctuation
      end
    rescue EOFError
      if @peeked_word_record or @peeked_orig_word_record
        raise RuntimeError
      else
        @postamble = @peeked_preamble
      end
    end

    return nil if sentence.words.empty?

    return sentence
  end

  def get_next_word(f)
    word = Word.new
    word.string, word.orig_string, word.preamble = get_word_header(f)

    get_word_tags(f, word)

    raise RuntimeError if word.tags.empty?

    return word
  end

  def get_word_tags(f, word)
    tags = []
    tag_index = 0

    while line = f.readline
      if is_tag_line(line)
        tag = Tag.new
        tag.lemma, tag.string, tag.correct, capitalized, u = get_tag(line)

        tag.index = tag_index
        word.end_of_sentence_p = u

        word.tags << tag
        tag_index += 1
      else
        peek line
        break
      end
    end

    raise RuntimeError if word.tags.empty?

    return tags
  end

  def get_word_header(f)
    header = nil

    if @peeked_word_record
      header = [@peeked_word_record, @peeked_orig_word_record, @peeled_preamble]
    elsif @peeked_orig_word_record
      @peeked_word_record = get_word(f.readline)
      header = [@peeked_word_record, @peeked_orig_word_record, @peeked_preamble]
    else
      while line = f.readline
        peek line

        break if @peeked_word_record
      end

      header = [@peeked_word_record, @peeked_orig_word_record, @peeked_preamble]
    end

    unpeek

    return header
  end

  def peek(line)
    if is_word_line(line)
      @peeked_word_record = get_word(line)
    elsif is_orig_word_line(line)
      @peeked_orig_word_record = get_orig_word(line)
    else
      if @peeked_preamble
        @peeked_preamble << line.strip
      else
        @peeked_preamble = [line.strip]
      end
    end
  end

  def unpeek()
    @peeked_word_record = nil
    @peeked_orig_word_record = nil
    @peeked_preamble = nil
  end

  def is_word_line(line)
    line.match(@word_regex)
  end

  def get_word(line)
    if (m = line.match(@word_regex)) then
      return m[1]
    end

    return nil
  end

  def is_tag_line(line)
    line.match(@tag_regex)
  end

  def get_tag(line)
    if (m = line.match(@tag_regex)) then
      lemma = m[1]
      tag = m[2]
      correct = !m[5].nil?
      capitalized = !m[3].nil?
      end_of_sentence = nil

      # detect end of sentence marker and remove it
      if tag.match("\s+<<<\s+")
        tag = tag.gsub(/\s+<<<\s+/, " ")
        end_of_sentence = true
      end

      return [lemma, tag, correct, capitalized, end_of_sentence]
    end

    return nil
  end

  # Checks if the passed line contains an original word string.
  # line - an OB output line
  # returns true if the line matches the original word line format, nil if not
  def is_orig_word_line(line)
    line.match(@orig_word_regex)
  end

  # Extracts the original word string if thtis line matches the original word line format, ie.
  # the word string in an XML word tag.
  # line - an OB output line
  # returns the original word string if the line matches, nil otherwise
  def get_orig_word(line)
    if m = line.match(@orig_word_regex)
      return m[1]
    end

    return nil
  end
end
