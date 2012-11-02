# -*- coding: utf-8 -*-

# -*- coding: utf-8 -*-
class Tag < ActiveRecord::Base
  belongs_to :word
  @@clean_tag_regex = Regexp.compile('((i|pa|tr|pr|r|rl|a|d|n)\d+(\/til)?)')

  # descriptions with accessors below
  @@gender_mark_list = ["mask", "fem", "nøyt"]
  @@gender_fem_mark = "fem"

  public
    
  def out_tag()
    self.string.strip.gsub(/\s+/, '_')
  end

  def clean_out_tag()
    self.string.gsub(@@clean_tag_regex, '').strip.gsub(/\s+/, '_')
  end
  
  # accessor for Class variable @@gender_mark_list
  # that contains an array of the tag mark strings for gender inflection values
  def Tag.gender_mark_list
    return @@gender_mark_list
  end
  
  # accessor for Class variable @@gender_fem_mark
  # that contains the feminine gender mark as a String
  def Tag.gender_fem_mark
    return @@gender_fem_mark
  end
end
