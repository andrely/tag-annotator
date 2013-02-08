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

    @focus = params[:focus] || 0

    # format is a reserved word, workaround to access field
    @format = TaggedText.find(@sentence.tagged_text_id)[:format]

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
        format.html
      else
        flash[:error] = "Database error! Mann over bord!"
        format.html { render :partial => 'error'}
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

  ##
  # Renders the sentence/word_browser partial. Used for updating views with ajax calls.
  #
  def word_browser
    @sentence = Sentence.find(params[:id])

    render(:partial => 'word_browser', :locals => {:words => @sentence.words})
  end

  ##
  # Adds a word to the sentence in relation to the word with the word id passed.
  # The position parameter can be 'before' or 'after' and specifies where the new
  # word is added in relation to the passed word id.
  #
  # The added word is initialized with string and orig_string fields from the passed
  # word_string and obt_word_string parameters.
  #
  def add_word
    @sentence = Sentence.find(params[:id])
    @word_id = params[:word_id]
    @position = params[:position]
    @word_string = (params[:word_string] || "").strip
    @obt_word_string = (params[:obt_word_string] || "").strip

    # redirect with error if the passed word string is empty
    if @word_string.empty?
      flash[:error] = "Couldn't add empty word"
      return redirect_to :controller =>  :sentences, :action => :show, :id => @sentence.id
    end

    if @obt_word_string.empty?
      @obt_word_string = @word_string.downcase
    end

    @sentence.add_word(@word_id, {:orig_string => @word_string, :string => @obt_word_string},
                       :position => @position)

    @sentence.save

    redirect_to :controller =>  :sentences, :action => :show, :id => @sentence.id
  end

  ##
  # Deletes the word in the sentence indentified by the parameter word_id
  #
  def delete_word
    @sentence = Sentence.find(params[:id])
    @word_id = params[:word_id]

    @sentence.delete_word(@word_id)

    @sentence.save

    redirect_to :controller =>  :sentences, :action => :show, :id => @sentence.id
  end
end
