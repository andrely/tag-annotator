class Sentence < ActiveRecord::Base
  has_many :words, :dependent => :destroy
  belongs_to :tagged_text

  accepts_nested_attributes_for :words, :allow_destroy => true

  def orth_string()
    words = self.words.sort_by {|w| w.sentence_index}
    strings = words.collect {|w| w.string}

    return strings.join(' ')
  end

  def context_string(index)
    left = index - 1
    if left < 0 then left = 0 end

    right = index + 1
    if right >= self.length then right = self.length end

    words = self.words[left .. right].collect {|w| w.string}
    string = words.join(' ')

    if left > 0 then string = '... ' + string end
    if right < (self.length - 1) then string = string + ' ...' end

    return string
  end

  def context_html_string(index)
    words = []

    

    left = index - 1
    if left >= 0 then
      words << "..." if left >= 1
      words << self.words[left].string
    end

    words << '<span class="selected-context">' + self.words[index].string + '</span>'

    right = index + 1
    if right < self.length then
      words << self.words[right].string
      words << "..." if right < self.length - 1
    end


    return words.join(' ')
  end

  # return the number of ambigious words
  # ie. words with more than one tag marked as correct
  def count_ambigous_words()
    words.find_all { |w| w.ambigious? }.count
  end
end
