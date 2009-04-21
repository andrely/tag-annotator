class TreeTagTrainer
  attr_accessor :lexicon, :text_id, :data, :classes

  def initialize(text_id)
    @text_id = text_id
    @punctuation_regex = Regexp.compile('^\$?[\.\:\|\?\!]$') # .:|!?
  end

  def make_lexicon()
    @lexicon = {}
    sentences = Sentence.find_all_by_tagged_text_id(@text_id)

    sentences.each do |s|
      words = Word.find_all_by_sentence_id(s.id)

      words.each do |w|
        entry = @lexicon[w.string]
        tag = get_correct_tag(w)
        new_entry = tag ? [tag.out_tag, tag.lemma] : ["ukjent", w.string]
        
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

  def make_training_data()
    @data = []
    @lexicon = {}
    classes = {}
    
    sentences = Sentence.find_all_by_tagged_text_id(@text_id)

    sentences.each do |s|
      words = Word.find_all_by_sentence_id(s.id)

      words.each do |w|
        tag = get_correct_tag(w)

        # strip punctuation tags
        if tag and w.string.match(@punctuation_regex)
          tag.string = 'clb'
        end
        
        # push on training data array
        @data.push [w.string.strip, tag ? tag.clean_out_tag : "ukjent"]
        
        # push on lexicon entry list
        entry = @lexicon[w.string]
        new_entry = tag ? [tag.clean_out_tag, tag.lemma] : ["ukjent", w.string]
        if entry.nil?
          @lexicon[w.string] = [new_entry] 
        elsif not entry.find { |x| x == new_entry }
          @lexicon[w.string] = entry.push(new_entry)
        end
        
        # push on known classes map
        tag ? classes[tag.clean_out_tag] = nil : classes['ukjent'] = nil
      end
    end

    @classes = classes.to_a.collect { |x| x.first }

    [@data, @lexicon, @open_classes]
  end

  def make_tag_list()
    classes = { }
    
     sentences = Sentence.find_all_by_tagged_text_id(@text_id)

    sentences.each do |s|
      words = Word.find_all_by_sentence_id(s.id)

      words.each do |w|
        tag = get_correct_tag(w)
        tag ? classes[tag.out_tag] = nil : classes['ukjent'] = nil
      end
    end
    
    @open_classes = classes.to_a.collect { |x| x.first }
  end

  def make_files(name)
    File.open(name + '.lex', 'w') do |f|
      @lexicon.each { |w, t| f.puts w + "\t" + t.collect{|x| x.join(' ')}.join("\t")}
    end

    File.open(name + '.train', 'w') do |f|
      @data.each { |d| f.puts d[0] + "\t" + d[1] }
    end

    File.open(name + '.class', 'w') do |f|
      @classes.each { |c| f.puts c }
    end
  end
end
