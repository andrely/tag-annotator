class WordsController < ApplicationController
  include ApplicationHelper

  def add_tag
    @word = Word.find(params[:id])

    # parameters are quoted to ensure proper encoding with javascript encodeURIComponent
    lemma = strip_quotes(params[:lemma] || "").strip
    tag_string = strip_quotes(params[:tag] || "").strip

    # return rendered partial and error code if the tag or lemma passed is empty
    if lemma.empty? or tag_string.empty?
      @sentence = Sentence.find(@word.sentence_id)
      return render(:partial => "sentences/word_details", :locals => {:wform => @word, :sent => @sentence},
                    :status => 400)
    end

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

    # parameters are quoted to ensure proper encoding with javascript encodeURIComponent
    new_form = strip_quotes((params[:word_form] || "")).strip
    new_obt_form = strip_quotes((params[:obt_word_form] || "")).strip

    # return rendered partial and error code if the word form passed is empty
    if new_form.strip.empty?
      @sentence = Sentence.find(@word.sentence_id)
      return render(:partial => "sentences/word_details", :status => 400,
                    :locals => {:wform => @word, :sent => @sentence})
    end

    if @word.orig_string
      @word.orig_string = new_form
      if new_obt_form.empty?
        # if there was an xml form in the original word and a separate OBT form is not passed,
        # create the OBT form from the passed word form.
        @word.string = obt_downcase(new_form)
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
