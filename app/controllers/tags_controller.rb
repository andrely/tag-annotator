class TagsController < ApplicationController
  include ApplicationHelper

  auto_complete_for :tag, :string
  auto_complete_for :tag, :lemma

  def toggle
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"

    @tag = Tag.find(params[:id])
    @status = params[:status] == 'true'

    if @status != @tag.correct?
      raise ArgumentError
    end

    @tag.correct = !@tag.correct
    @tag.save

    render :nothing => true
  end

  def delete
    @tag = Tag.find(params[:id])
    @tag.destroy

    @word = Word.find(@tag.word_id)

    @word.tags.each_with_index {|tag, i| tag.index = i}
    @word.save

    @sentence = Sentence.find(@word.sentence_id)
    
    render(:partial => 'sentences/word_details', :locals => {:wform => @word, :sent => @sentence})
  end

  # updates the tag with sent tag (ie. tag_string) and/or lemma parameters
  def update
    @tag = Tag.find(params[:id])

    @focus = params[:focus] || 0
    @word = Word.find(@tag.word_id)
    @sentence = Sentence.find(@word.sentence_id)

    # strip quotes added by javascript encodeURIComponent
    if params[:tag]
      tag_string = strip_quotes(params[:tag][:string] || "").strip if params[:tag]
    else
      tag_string = ""
    end
    
    lemma_string = strip_quotes(params[:lemma] || "").strip

    if not tag_string.empty?
      @tag.string = tag_string
    end

    if not lemma_string.empty?
      @tag.lemma = lemma_string
    end

    @tag.save

    redirect_to :controller => :sentences, :action => :show, :id => @sentence.id, :focus => @focus
  end
end
