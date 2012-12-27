# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def text_field_with_auto_complete_with_id_checking(object, method,
      tag_options = {}, completion_options = {})
    # lets just set the id now and not worry about it throughout
    id = tag_options[:id] || "#{object}_#{method}"

    (completion_options[:skip_style] ? "" : auto_complete_stylesheet) +
        text_field(object, method, tag_options) +
        content_tag("div", "", :id => "#{id}_auto_complete", :class =>
            "auto_complete") +
        auto_complete_field(id,
                            { :url => { :action =>
                                            "auto_complete_for_#{object}_#{method}" } }.update(completion_options))
  end

  ##
  # Mimic downcasing as done by OBT multitagger, ie. downcase only first letter.
  # See issue #12
  #
  def obt_downcase(str)
    str = str[0...1].downcase + str[1..-1]
  end

  ##
  # Strips enclosing quotes from string
  #
  def strip_quotes(str)
    if str[0] == 34 and str[-1] == 34 and str.size > 1
      str = str[1..-2]
    end

    str
  end
end
