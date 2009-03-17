class SentencesController < ApplicationController
  layout "default"
  
  # GET /sentences/1
  # GET /sentences/1.xml
  def show
    @sentence = Sentence.find(params[:id])
    @words = @sentence.words.sort_by {|w| w.sentence_index}
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sentence }
    end
  end
end
