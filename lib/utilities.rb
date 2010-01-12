def write_disambiguated_file(text_id, outfile)
  File.open(outfile, 'w') do |file|
    TaggedText.find(text_id).sentences.each do |s|
      s.words.each do |w|
        file.puts w.string + "\t" + w.tags.collect { |t| t.clean_out_tag }.join(' ')
      end

      file.puts
    end
  end
  
  nil
end

def find_ambigious_sentences(text_id)
  TaggedText.find(text_id).sentences.find_all do |s|
    s.count_ambigious_words > 0
  end
end
