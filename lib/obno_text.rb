# -*- coding: utf-8 -*-
class OBNOText
  attr_accessor :test

  @word_regex = Regexp.compile('\"<(.*)>\"')
  @tag_regex = Regexp.compile('^\s+\"(.*)\"\s+([^\!]*)\s+(<Correct\!>)?')
  @punctuation_regex = Regexp.compile('^[\.\?\!]$')

  def initialize()
    @test = <<DOC
"<for>"
	"fare" verb pret a3 pa4 tr11 pa5 pr11 
	"for" clb konj 
	"for" adv 
	"for" prep 	<Correct!>
	"fore" verb imp 
"<jenter>"
	"jente" subst fem appell fl ub 	<Correct!>
	"jente" subst mask appell fl ub 	<Correct!>
"<er>"
	"være" verb pres pr1 pr2 <aux1/perf_part> a5 	<Correct!>
"<shopping>"
	"shopping" subst fem appell ent ub 
	"shopping" subst mask appell ent ub 	<Correct!>
"<mye>"
	"mye" adj pos be ent 
	"mye" adj pos fl 
	"mye" adj pos m/f ub ent 
	"mye" adj pos nøyt ub ent 	<Correct!>
"<mer>"
	"mye" adj komp 	<Correct!>
"<$,>"
	"$," clb <komma> 	<Correct!>
	"$," <komma> 
"<det>"
	"det" det dem nøyt ent 
	"det" pron pers 3 ent nøyt 	<Correct!>
"<er>"
	"være" verb pres pr1 pr2 <aux1/perf_part> a5 	<Correct!>
"<mentalhygiene>"
	"mentalhygiene" subst mask appell ent ub 	<Correct!>
"<$,>"
	"$," clb <komma> 
	"$," <komma> 	<Correct!>
"<vitamininnsprøytning>"
	"vitamininnsprøytning" subst mask appell ent ub 	<Correct!>
"<$,>"
	"$," clb <komma> 	<Correct!>
	"$," <komma> 
"<det>"
	"det" det dem nøyt ent 
	"det" pron pers 3 ent nøyt 	<Correct!>
"<er>"
	"være" verb pres pr1 pr2 <aux1/perf_part> a5 	<Correct!>
"<glede>"
	"glede" subst fem appell ent ub 	<Correct!>
	"glede" subst mask appell ent ub 	<Correct!>
	"glede" verb inf tr10 rl1 rl12 rl12/til rl16 rl16/til rl17 rl17/til 
"<$,>"
	"$," clb <komma> 
	"$," <komma> 	<Correct!>
"<spenning>"
	"spenning" subst mask appell ent ub 	<Correct!>
"<$,>"
	"$," clb <komma> 
	"$," <komma> 	<Correct!>
"<belønning>"
	"belønning" subst fem appell ent ub 	<Correct!>
	"belønning" subst mask appell ent ub 	<Correct!>
"<og>"
	"og" clb konj 
	"og" adv 
	"og" konj 	<Correct!>
"<trøst>"
	"trøst" subst fem appell ent ub 	<Correct!>
	"trøst" subst mask appell ent ub 	<Correct!>
	"trøste" verb imp tr1 rl9 
"<$.>"
	"$." clb <PUNKT> 	<Correct!>
"<vi>"
	"vi" pron pers 1 fl hum nom 	<Correct!>
	"vie" verb imp tr1 d7/til d1 
"<kjøper>"
	"kjøpe" verb pres tr1 d1 d4 rl6 tr11 i 	<Correct!>
	"kjøper" subst mask appell ent ub 
"<ting>"
	"ting" subst mask appell ent ub 	<Correct!>
	"ting" subst mask appell fl ub 	<Correct!>
	"ting" subst nøyt appell ent ub 	<Correct!>
	"ting" subst nøyt appell fl ub 	<Correct!>
	"tinge" verb imp tr1 tr11 
"<fordi>"
	"fordi" sbu 	<Correct!>
"<vi>"
	"vi" pron pers 1 fl hum nom 	<Correct!>
	"vie" verb imp tr1 d7/til d1 
"<kjeder>"
	"kjede" subst mask appell fl ub 
	"kjede" subst nøyt appell fl ub 
	"kjede" verb pres pa1 	<Correct!>
	"kjede" verb pres rl1 tr10 	<Correct!>
"<oss>"
	"vi" pron pers 1 fl hum akk 	<Correct!>
"<$,>"
	"$," clb <komma> 
	"$," <komma> 	<Correct!>
"<fordi>"
	"fordi" sbu 	<Correct!>
"<vi>"
	"vi" pron pers 1 fl hum nom 	<Correct!>
	"vie" verb imp tr1 d7/til d1 
"<er>"
	"være" verb pres pr1 pr2 <aux1/perf_part> a5 	<Correct!>
"<deprimerte>"
	"deprimere" adj <perf-part> be ent tr10 
	"deprimere" adj <perf-part> fl tr10 
	"deprimere" verb pret tr10 
	"deprimert" adj pos be ent 
	"deprimert" adj pos fl 	<Correct!>
"<og>"
	"og" clb konj 
	"og" adv 
	"og" konj 	<Correct!>
"<ensomme>"
	"ensom" adj pos be ent 
	"ensom" adj pos fl 	<Correct!>
"<$,>"
	"$," clb <komma> 	<Correct!>
	"$," <komma> 
"<vi>"
	"vi" pron pers 1 fl hum nom 	<Correct!>
	"vie" verb imp tr1 d7/til d1 
"<kjøper>"
	"kjøpe" verb pres tr1 d1 d4 rl6 tr11 i 	<Correct!>
	"kjøper" subst mask appell ent ub 
"<for>"
	"fare" verb pret a3 pa4 tr11 pa5 pr11 
	"for" clb konj 
	"for" adv 
	"for" prep 	<Correct!>
	"fore" verb imp 
"<å>"
	"å" inf-merke 	<Correct!>
	"å" interj 
	"å" subst fem appell ent ub 
	"å" subst mask appell ent ub 
"<bygge>"
	"bygge" verb inf i1 tr9 pa1 pa2 	<Correct!>
"<opp>"
	"opp" prep 	<Correct!>
"<selvfølelsen>"
	"selvfølelse" subst mask appell ent be 	<Correct!>
"<og>"
	"og" clb konj 
	"og" adv 
	"og" konj 	<Correct!>
"<for>"
	"fare" verb pret a3 pa4 tr11 pa5 pr11 
	"for" clb konj 
	"for" adv 
	"for" prep 	<Correct!>
	"fore" verb imp 
"<å>"
	"å" inf-merke 	<Correct!>
	"å" interj 
	"å" subst fem appell ent ub 
	"å" subst mask appell ent ub 
"<føle>"
	"føle" verb inf tr1 tr8 a11 tr16 tr11 a8 pr6 pr9 	<Correct!>
"<oss>"
	"vi" pron pers 1 fl hum akk 	<Correct!>
"<vel>"
	"vel" adv 	<Correct!>
	"vel" subst nøyt appell ent ub 
	"vel" subst nøyt appell fl ub 
	"vel" subst nøyt appell ubøy 
"<$.>"
	"$." clb <PUNKT> 	<Correct!>
DOC
    
  end

  def self.parse(textinst, file)
    word = nil
    sentence = Sentence.new
    sent_count = 0
    index = 0
    tag_index = 0
    file = File.new(file, 'r')
    while (line = file.gets)
      if isWordLine(line) then
        word = Word.new
        word.string = getWord(line)
        word.sentence_index = index
        word.tag_count = tag_index
        sentence.words << word
        index += 1
        tag_index = 0

        if isPunctuation(word.string) then
          sentence.length = index
          sentence.text_index = sent_count
          textinst.sentences << sentence
          sentence = Sentence.new
          index = 0
          sent_count += 1
        end
      end

      if isTagLine(line) then
        tag = Tag.new
        lemma, string, correct = getTag(line)
        tag.lemma = lemma
        tag.string = string
        tag.correct = correct
        tag.index = tag_index
        tag_index += 1
        word.tags << tag
      end
    end

    if index > 0 then
      sentence.length = index
      sentence.text_index = sent_count
      textinst.sentences << sentence
      sent_count += 1
    end
    textinst.sentence_count = sent_count
    textinst.save!
  end

  def self.writeFile(text, file)
    File.open(file, 'w') do |f|
      sentences = text.sentences.sort_by {|s| s.text_index }
      sentences.each do |s|
        words = s.words.sort_by {|w| w.sentence_index }
        words.each do |w|
          f.puts '"<' + w.string + '>"'
          tags = w.tags.sort_by {|t| t.index }
          tags.each do |t|
            f.puts "\t" + '"' + t.lemma + '" ' + t.string + (t.correct ? ' <Correct!>' : '')
          end
        end
      end
    end

    true
  end

  def self.isWordLine(line)
    line.match(@word_regex)
  end

  def self.getWord(line)
    if (m = line.match(@word_regex)) then
      return m[1]
    end

    return nil
  end

  def self.isTagLine(line)
    line.match(@tag_regex)
  end

  def self.getTag(line)
    if (m = line.match(@tag_regex)) then
      return [m[1], m[2], !m[3].nil?]
    end

    return nil
  end

  def self.isPunctuation(str)
    return str.match(@punctuation_regex)
  end
end
