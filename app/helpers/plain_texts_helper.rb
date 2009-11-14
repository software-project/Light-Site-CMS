module PlainTextsHelper

  def preview_text(item)
    if item.showed_signs_on_preview != 0
      get_preview_text(item.content,item.showed_signs_on_preview)
    else
      item.content
    end
  end

  private
  def get_preview_text(html,target_signs)
    counter = 1
    tag_is_open = false
    text_code_open = false
    html.each_byte{|sign|
      if sign == 60
        tag_is_open = true
      elsif sign == 62
        tag_is_open = false
      elsif sign == 38
        text_code_open = true
      elsif sign == 59
        text_code_open = false        
      else
        if !tag_is_open and !text_code_open
          target_signs -= 1
        end        
      end
      counter += 1
      if target_signs == 0
        return close_tags(html[0..counter])
      end
    }
    html
  end
end

def close_tags(text)
    open_tags = []
    text.scan(/\<([^\>\s\/]+)[^\>\/]*?\>/).each { |t| open_tags.unshift(t) }
    text.scan(/\<\/([^\>\s\/]+)[^\>]*?\>/).each { |t| open_tags.slice!(open_tags.index(t)) }
    open_tags.each {|t| text += "</#{t}>" }
    text
  end

