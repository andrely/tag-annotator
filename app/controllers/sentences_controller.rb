class SentencesController < ApplicationController
  layout "default"

  # after_filter :discard_flash_if_xhr

#   protected
#   def discard_flash_if_xhr
#     flash.discard if request.xhr?
#   end

  public
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
  
  def reload_flash
    page.replace "flash_messages", :partial => 'layouts/flash', :object => flash
  end

  # PUT /tagged_texts/1
  # PUT /tagged_texts/1.xml
  def update
    @sentence = Sentence.find(params[:id])

    respond_to do |format|
      if @sentence.update_attributes(params[:sentence])
        format.js
      else
        flash[:error] = "Database error! Mann over bord!"
        format.js
      end
    end
  end

  def add_bookmark
    @sentence = Sentence.find(params[:sentence_id])
    @bookmark = Bookmark.new(:sentence_id => @sentence.id, :tagged_text_id => @sentence.tagged_text_id)

    # add error handling
    @bookmark.save
    respond_to do |format|
      format.js
    end
  end
end
