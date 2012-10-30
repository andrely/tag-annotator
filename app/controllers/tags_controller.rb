class TagsController < ApplicationController
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
end
