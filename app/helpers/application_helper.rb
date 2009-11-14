# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper
  require 'iconv'
  
  def t_collection(collection)
    collection.each { |i|
      i.name = t(i.class.to_s.downcase + "." + i.name.downcase)
    }
    collection
  end

  def show_baner
    if session[:show_baner].nil?
      session[:show_baner] = false
      return "true"
    else
      return "false"
    end
  end

  def permalink(str, separator='-')
    return "" if str.blank? # hack if the str/attribute is nil/blank
    re_separator = Regexp.escape(separator)
    result = str.mb_chars.downcase.strip.normalize(:kd)
    result.gsub!(/[^\x00-\x7F]+/, '') # Remove non-ASCII (e.g. diacritics).
    result.gsub!(/[^a-z0-9\-_\+]+/i, separator) # Turn non-slug chars into the separator.
    result.gsub!(/#{re_separator}{2,}/, separator) # No more than one of the separator in a row.
    result.gsub!(/^#{re_separator}|#{re_separator}$/, '') # Remove leading/trailing separator.
    result
  end
end
