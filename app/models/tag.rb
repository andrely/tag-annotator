class Tag < ActiveRecord::Base
  belongs_to :word
  @@clean_tag_regex = Regexp.compile('((i|pa|tr|pr|r|rl|a|d|n)\d+(\/til)?)')

  public
    
  def out_tag()
    self.string.strip.gsub(/\s+/, '_')
  end

  def clean_out_tag()
    self.string.gsub(@@clean_tag_regex, '').strip.gsub(/\s+/, '_')
  end
end
