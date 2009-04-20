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

end
