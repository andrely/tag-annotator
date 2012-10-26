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

end
