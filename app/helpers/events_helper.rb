module EventsHelper
  
  def preview_event(item)
    if item.char_showed != 0
      item.content[0..item.char_showed]
    else
      item.content
    end
  end
end
