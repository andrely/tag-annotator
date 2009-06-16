class TaggedText < ActiveRecord::Base
  has_many :sentences, :dependent => :destroy
  has_many :bookmarks, :dependent => :destroy
  
  # validates_format_of :content_type, :with => /^text/, :message => '--- you can only upload text files'
  def uploaded_file=(file_field)
    self.filename = base_part_of(file_field.original_filename)
    # self.content_type = file_field.content_type.chomp
    # self.filedata = file_field.read

    # OBNOText.parse(self, self.filedata)
    OBNOText.parse(self, Iconv.conv('utf8', 'iso8859-1', file_field.read))
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
          f.puts w.string + "\t" + tag_strings.join("\t")
        end

        f.puts
      end
    end

    nil
  end
end
