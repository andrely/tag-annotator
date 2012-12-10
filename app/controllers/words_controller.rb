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

  ##
  # Renders the sentences/word_details partial the passed word id. Used to update views by ajax.
  #
  def word_details
    @word = Word.find(params[:id])
    @sentence = Sentence.find(@word.sentence_id)

    render(:partial => "sentences/word_details", :locals => {:wform => @word, :sent => @sentence})
  end

  def change_form
    @word = Word.find(params[:id])
    new_form = params[:word_form].strip
    new_obt_form = params[:obt_word_form].strip

    if @word.orig_string
      @word.orig_string = new_form
      if new_obt_form.empty?
        @word.string = new_form.downcase
      else
        @word.string = new_obt_form
      end
    else
      @word.string = new_form
    end

    @word.save

    @sentence = Sentence.find(@word.sentence_id)

    render(:partial => "sentences/word_details", :locals => {:wform => @word, :sent => @sentence})
  end
end
