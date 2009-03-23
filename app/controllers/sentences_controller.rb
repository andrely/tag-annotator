class SentencesController < ApplicationController
  layout "default"
  
  # GET /sentences/1
  # GET /sentences/1.xml
  def show
    @sentence = Sentence.find(params[:id])
    @words = @sentence.words.sort_by {|w| w.sentence_index}
    @next_sent =
      Sentence.find(:all, :conditions => ["text_index  = ? and tagged_text_id = ?", @sentence.text_index+1, @sentence.tagged_text_id])[0]
    @prev_sent =
      Sentence.find(:all, :conditions => ["text_index  = ? and tagged_text_id = ?", @sentence.text_index-1, @sentence.tagged_text_id])[0]
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sentence }
    end
  end

  # PUT /tagged_texts/1
  # PUT /tagged_texts/1.xml
  def update
    @sentence = Sentence.find(params[:id])

    respond_to do |format|
      if @sentence.update_attributes(params[:sentence])
        flash[:notice] = 'Sentence successfully updated.'
        format.html { redirect_to(@sentence) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sentence.errors, :status => :unprocessable_entity }
      end
    end
  end

end
