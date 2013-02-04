class TaggedText < ActiveRecord::Base
  has_many :sentences, :order => 'text_index', :dependent => :destroy
  has_many :bookmarks, :dependent => :destroy

  def words
    the_words = []
    sentences.each { |s| the_words = the_words + s.words }

    the_words
  end
  
  # validates_format_of :content_type, :with => /^text/, :message => '--- you can only upload text files'
  def uploaded_file=(file_field)
    self.filename = base_part_of(file_field.original_filename)

    f_str = Iconv.conv('utf-8', self.encoding, file_field.read)

    f = StringIO.new(f_str)

    if self.format == 'OBT'
      it = OBNOTextIterator.new(f, self.sentence_delimiter == 'delimiter')
    elsif self.format == 'VRT'
      it = VRTReader.new(f)
    else
      raise RuntimeError
    end

    it.each_sentence {|s| sentences << s}
    f.close()
  end

  def base_part_of(file_name) 
    File.basename(file_name).gsub(/[^\w._-]/, '') 
  end 
  
  # saves the tagged text with ambiguities to the filename given
  # file_name - the filename path as a string
  # returns nil
  def save_ambigious_file(file_name)
    File.open(file_name, 'w') do |f|
      sentences.each do |s|
        s.words.each do |w|
          tag_strings = w.get_correct_tags().collect { |t| t.clean_out_tag }
          tag_strings = ['unkjent_ord'] if tag_strings.count == 0
          f.puts w.norm_string + "\t" + tag_strings.sort.join("\t")
        end

        f.puts
      end
    end

    nil
  end

  # saves all ambigious words in the text (with tags) to the given file
  # file_name - the filename path as a string
  # returns nil
  def save_ambigious_words(file_name)
    File.open(file_name, 'w') do |f|
      sentences.each do |s|
        s.words.each do |w|
          tag_strings = w.get_correct_tags().collect { |t| t.clean_out_tag }
          f.puts w.string + "\t" + tag_strings.sort.join("\t") if tag_strings.count > 1
        end
      end
    end

    nil
  end
  
  # saves a cleaned up ob cor file as the filename specified.
  # this means that duplicat clean form tags are removed and som ambiguities are resolved
  # heuristically. these are:
  # - nouns which are ambigious in gender only are disambiguited to female
  # file_name - the filename as a string
  # returns nil
  def save_cleaned_cor_file(file_name)
    File.open(file_name, 'w') do |f|
      sentences.each do |s|
        s.words.each do |w|
          if w.ambigious? and w.clean_tag_ambiguity?
            w.remove_clean_tag_ambiguity
          elsif w.ambigious? and w.noun_gender_ambiguity?
            w.remove_noun_gender_ambiguity
          end
          f.puts '"<' + w.string + '>"'

          w.tags.each do |t|
            f.puts "\t\"#{t.lemma}\" #{t.string} " + (t.correct ? "\t<Correct!>" : "")
          end
        end
      end
    end

    nil
  end

  def save_mbt_file(filename)
    File.open(filename, 'w') do |f|
      sentences.each do |s|
        s.words.each do |w|
          correct_num = w.get_correct_tags.length
          puts w.id
          if correct_num > 1
            raise RuntimeError, 'Ambigious word'
          elsif correct_num = 0
            f.puts "#{w.string}\tukjent_ord"
          else
            tag = w.get_correct_tag
            f.puts "#{w.string}\t#{tag.clean_out_tag}"
          end
        end
      end

      f.puts '<utt>'
    end
  end

  def find_ambigious_words
    words = []
    
    sentences.each do |s|
      s.words.each do |w|
        correct_num = w.get_correct_tags.length
        if correct_num > 1
          words << w
        end
      end
    end

    return words
  end

  def save_tt_lexicon(filename)
    the_words = { }

    words.each do |w|
      t = w.get_correct_tag
      tag = [ w.get_correct_tag.clean_out_tag, w.get_correct_tag.lemma ] if t
      tag = [ "ukjent_ord", w.norm_string] if t.nil?
      word_tags = the_words[w.norm_string]
      if word_tags
        word_tags << tag if not word_tags.include? tag
      else
        the_words[w.norm_string] = [tag]
      end
    end

    the_words = the_words.to_a.sort!

    File.open(filename, 'w') do |f|
      the_words.each do |w|
        # TODO same tag different lemma must be separate entries
         f.puts w.first + "\t" + w[1].collect{ |t| t.join(' ') }.join("\t")
      end
    end

    nil
  end

  def save_tt_class_file(filename)
    seen_classes = { }

    
    words.each do |w|
      w.tags.each do |t|
        seen_classes[t.clean_out_tag] = true
      end
    end
        
    File.open(filename, 'w') do |f|
      f.puts seen_classes.keys.sort.join("\n")
    end
  end

  def self.encodings
    ["utf-8", "latin1"]
  end

  def self.formats
    ["OBT", "VRT"]
  end
end
