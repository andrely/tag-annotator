class Word < ActiveRecord::Base
  belongs_to :sentence
  has_many :tags, :dependent => :destroy

  accepts_nested_attributes_for :tags, :allow_destroy => true

  def get_correct_tag()
    (self.tags.detect { |t| t.correct }) || Tag.new(:string => 'ukjent')
  end
  
  # returns an array of the tags for the word that is marked as correct
  def get_correct_tags()
    tags.find_all { |t| t.correct }
  end
  
  # returns the number of tags marked as correct for this word
  def get_ambiguity()
    Tag.find(:all, :conditions => "correct = true and word_id = #{self.id}").count
  end
  
  # returns true if there are more than one reading false otherwise
  # ignores zero and negative numbers (ie. returns true)
  def ambigious?()
    get_ambiguity != 1
  end
end
