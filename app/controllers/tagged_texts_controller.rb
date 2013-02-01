class TaggedTextsController < ApplicationController
  layout "default"
  
  # GET /tagged_texts
  # GET /tagged_texts.xml
  def index
    @tagged_texts = TaggedText.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tagged_texts }
    end
  end

  # GET /tagged_texts/1
  # GET /tagged_texts/1.xml
  def show
    @tagged_text = TaggedText.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tagged_text }
    end
  end

  # GET /tagged_texts/new
  # GET /tagged_texts/new.xml
  def new
    @tagged_text = TaggedText.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tagged_text }
    end
  end

  # GET /tagged_texts/1/edit
  def edit
    @tagged_text = TaggedText.find(params[:id])
  end

  # POST /tagged_texts
  # POST /tagged_texts.xml
  def create
    @tagged_text = TaggedText.new()
    @tagged_text.encoding = params[:tagged_text][:encoding]
    @tagged_text.format = params[:tagged_text][:format]
    @tagged_text.sentence_delimiter = params[:obt_sentence_boundary_select] || nil
    @tagged_text.uploaded_file = params[:tagged_text][:uploaded_file]
    @tagged_text.title = params[:tagged_text][:title]
    @tagged_text.comment = params[:tagged_text][:comment]

    @tagged_text.sentence_count = @tagged_text.sentences.count

    @tagged_text.save!

    respond_to do |format|
      if @tagged_text.save
        flash[:notice] = 'TaggedText was successfully created.'
        format.html { redirect_to(@tagged_text) }
        format.xml  { render :xml => @tagged_text, :status => :created, :location => @tagged_text }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tagged_text.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tagged_texts/1
  # PUT /tagged_texts/1.xml
  def update
    @tagged_text = TaggedText.find(params[:id])

    respond_to do |format|
      if @tagged_text.update_attributes(params[:tagged_text])
        flash[:notice] = 'TaggedText was successfully updated.'
        format.html { redirect_to(@tagged_text) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tagged_text.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tagged_texts/1
  # DELETE /tagged_texts/1.xml
  def destroy
    @tagged_text = TaggedText.find(params[:id])
    @tagged_text.destroy

    respond_to do |format|
      format.html { redirect_to(tagged_texts_url) }
      format.xml  { head :ok }
    end
  end

  def download
    @tagged_text = TaggedText.find(params[:id])
    
    str = Iconv.conv(@tagged_text.encoding, 'utf-8', OBNOText.textString(@tagged_text))

    send_data(str, :filename => @tagged_text.filename, :type => 'plain/txt', :disposition => 'attachment')
  end

  def list
    @sentences = Sentence.find_all_by_tagged_text_id(params[:id])
  end

  ##
  # Responds with the options partial for the file format sent as parameter.
  # Current formats: OBT, VRT.
  def format_options
    @file_format = params[:file_format].downcase.to_sym

    render(:partial => 'text_format_options', :locals => {:file_format => @file_format})
  end
end
