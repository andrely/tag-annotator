class TaggedTextsController < ApplicationController
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
    @tagged_text = TaggedText.new(params[:tagged_text])

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
end
