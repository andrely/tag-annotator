class WordsController < ApplicationController
  def add_tag
    @word = Word.find(params[:id])

    lemma = params[:lemma]
    tag_string = params[:tag]

    tag = Tag.new
    tag.lemma = lemma
    tag.string = tag_string
    tag.word_id = @word.id
    tag.correct = true
    tag.index = @word.tags.count

    @word.tags.insert(-1, tag)
    @word.save

    @sentence = Sentence.find(@word.sentence_id)

    render(:partial => "sentences/word_details", :locals => {:wform => @word, :sent => @sentence})
  end

end
