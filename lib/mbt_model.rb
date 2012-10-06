class MBTModel < Model
  attr_accessor :lexicon, :ambitag_lexicon, :most_freq, :settings, :known_words, :unknown_words

  @@file_suffixes = {
    :lexicon => 'lex',
    :ambitag_lexicon => 'lex.ambi.05',
    :most_freq => 'top100',
    :settings => 'settings',
    :known_words => 'known.ddfa',
    :unknown_words => 'unknown.dFapsss'
  }

  def initialize(opts={})
    @settings = opts[:settings] || nil
  end
end
