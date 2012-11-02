class Word < ActiveRecord::Base
  belongs_to :sentence
  has_many :tags, :dependent => :destroy

  accepts_nested_attributes_for :tags, :allow_destroy => true

  @@punctuation_regex = Regexp.compile('^\$?[\.\:\|\?\!]$') # .:|!?
  
  def norm_string
    if string.match(/\s/)
      return string.split(/\s/).join('_')
    else
      return string
    end
  end
  
  def get_taggedtext
    self.sentence.taggedtext if self.sentence
  end
  
  def tag_count
    tags.count
  end

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

  # checks if the tags of this word contains duplicate tags when listed in clean form
  # returns true if duplicates founhd, false otherwise
  def clean_tag_ambiguity?
    clean_tags = tags.collect { |t| t.lemma + " " + t.clean_out_tag }

    clean_tags.count != clean_tags.uniq.count
  end
  
  # removes the correct flag from tags which have a clean tag already present
  # in the words tag list
  # does not save to activerecord store
  # returns the word instance
  def remove_clean_tag_ambiguity
    clean_tag_list = []

    get_correct_tags.each do |t|
      # include lemma when testing
      clean_tag = t.lemma + " " + t.clean_out_tag
      if clean_tag_list.include?(clean_tag)
        t.correct = false
        # to be implemented ?
        # t.auto_disambiguated = true
      else
        clean_tag_list << clean_tag
      end
    end

    return self
  end

  # check the word for ambiguities among noun tags that only differ in the gender value
  # returns a list of ambiguities, each containing a list of the ambiious tags
  def get_noun_gender_ambiguities
    result = []
    
    correct_tags = get_correct_tags
    correct_tags.each_index do |i|
      tag = correct_tags[i]
      rest = correct_tags[(i + 1)..correct_tags.count]

      tag_mark_list = tag.string.split(/\s/)

      next if not tag_mark_list.include?("subst")

      amb = []

      rest.each do |r|
        r_mark_list = r.string.split(/\s/)

        # check the cross-set differences between the tag mark lists
        x = tag_mark_list - r_mark_list
        y = r_mark_list - tag_mark_list
        
        # we got one if both differences are one item from the appropriate set of marks
        if (x.count == 1 and y.count == 1) and (Tag.gender_mark_list.include?(x.first)) and (Tag.gender_mark_list.include?(y.first))
          amb << tag
          amb << r
        end
      end

      # check that the ambiguity found has the same lemma
      result << amb.uniq if amb.collect { |tag| tag.lemma }.uniq.count == 1
    end

    return result
  end

  # Predicate for checking if noun ambiguities concerning only the gender is
  # present among the tags of the word
  # returns true if present, false otherwise
  def noun_gender_ambiguity?
    return get_noun_gender_ambiguities ? true : false
  end
  
  # Removes noun gender ambiguites identified by the two methods noun_gender_ambiguity?()
  # and get_noun_gender_ambiguities(). It keeps the tag containing the feminine gender mark,
  # if it is not present the ambiguity is not removed.
  # returns the modified Word instance
  def remove_noun_gender_ambiguity
    ambiguities = get_noun_gender_ambiguities

    ambiguities.each do |amb|
      next unless amb.detect { |tag| tag.string.match(/\sfem\s/) }
      amb.each do |tag|
        tag.correct = false unless tag.string.match(/\sfem\s/)
      end
    end

    self
  end

  def add_tag()

  end

  def is_punctuation?
    return string.match(@@punctuation_regex)
  end
end
