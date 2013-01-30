class Sentence < ActiveRecord::Base
  has_many :words, :order => 'sentence_index', :dependent => :destroy
  belongs_to :tagged_text

  accepts_nested_attributes_for :words, :allow_destroy => true

  def printable_string
    words = self.words.sort_by {|w| w.sentence_index}
    strings = words.collect {|w| w.printable_string}

    return strings.join(' ')
  end

  def length
    self.words.count
  end

  def orth_string()
    words = self.words.sort_by {|w| w.sentence_index}
    strings = words.collect {|w| w.string}

    return strings.join(' ')
  end
  
  def tag_count
    words.inject(0) { |i, w| i + w.tag_count }
  end
  
  def context_string(index)
    left = index - 1
    if left < 0 then left = 0 end

    right = index + 1
    if right >= self.length then right = self.length end

    words = self.words[left .. right].collect {|w| w.string}
    string = words.join(' ')

    if left > 0 then string = '... ' + string end
    if right < (self.length - 1) then string = string + ' ...' end

    return string
  end

  def context_html_string(index)
    words = []

    left = index - 1
    if left >= 0 then
      words << "..." if left >= 1
      words << self.words[left].printable_string
    end

    words << '<span class="selected-context">' + self.words[index].printable_string + '</span>'

    right = index + 1
    if right < self.length then
      words << self.words[right].printable_string
      words << "..." if right < self.length - 1
    end


    return words.join(' ')
  end

  # return the number of ambigious words
  # ie. words with more than one tag marked as correct
  def count_ambigious_words()
    words.find_all { |w| w.ambigious? }.count
  end

  ##
  # Adds a word to the sentence instance populated with word_args before or after the word specified
  # by the word_id. :position key specifies :before or :after (:after is the default).
  #
  def add_word(word_id, word_args, opts = {})
    position = (opts[:position] || :after).to_sym

    word = Word.find(word_id)
    index = word.sentence_index

    if not word == words[index]
      raise ArgumentError
    end

    new_word = Word.new(word_args)

    if position == :after
      index += 1
    end

    # increment index of words after insertion
    new_word.sentence_index = index
    words[index..-1].each {|w| w.sentence_index += 1}

    # add word
    words << new_word

    # sort the words in the current instance
    words.sort_by {|x| x.sentence_index}

    return self
  end

  ##
  # Removes the word identified by the word_id from the sentence instance.
  #
  def delete_word(word_id)
    word = Word.find(word_id)
    index = word.sentence_index

    if not word == words[index]
      raise ArgumentError
    end

    self.words.delete(word)

    # reset indices to remove any gap
    words.each_with_index {|w, i| w.sentence_index = i}

    return self
  end

  ##
  # Returns true if there exists a bookmark for the sentence
  # in the database, false otherwise.
  #
  def is_bookmarked?
    return Bookmark.exists?(:tagged_text_id => self.tagged_text_id,
                            :sentence_id => self.id)
  end
end
