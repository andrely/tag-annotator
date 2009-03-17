class Sentence < ActiveRecord::Base
  has_many :words
  belongs_to :taggedtext

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
end
