class TreeTagTrainer
  attr_accessor :lexicon, :text_id

  def initialize(text_id)
    @text_id = text_id
  end

  def make_lexicon()
    @lexicon = {}
    sentences = Sentence.find_all_by_tagged_text_id(@text_id)

    sentences.each do |s|
      words = Word.find_all_by_sentence_id(s.id)

      words.each do |w|
        entry = @lexicon[w.string]
        tag = get_correct_tag(w)
        new_entry = [tag.string, tag.lemma]
        
        if entry.nil?
          @lexicon[w.string] = [new_entry] 
        elsif not entry.find { |x| x == new_entry }
          @lexicon[w.string] = entry.push(new_entry)
        end
      end
    end

    @lexicon
  end

  def get_correct_tag(word)
    tags = Tag.find_all_by_word_id(word.id)

    tags.find { |t| t.correct }
  end
end
