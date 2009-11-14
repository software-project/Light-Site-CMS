module CkfinderHelper

  def tooltip_menu(item_obj)
    html = "<div style=\"display:none\"><ul id=\"#{item_obj.class.to_s + "_#{item_obj.id}"}\">"
#      "<li><a href=\"#{item_obj.public_filename}\">#{t("oryginal")} (#{item_obj.width}:#{item_obj.height})</a></li>"
    html << "<li>#{linker(item_obj.public_filename)}
            #{t("oryginal")} (#{item_obj.width}:#{item_obj.height})</div></li>"
    item = Object.const_get(item_obj.class.to_s)
    items = item.find(:all, :conditions => ["parent_id = ?",item_obj.id])
    items.each{|i|
      html << "<li>#{linker(i.public_filename)}#{i.thumbnail.to_s} (#{i.width}:#{i.height})</div></li>"
    }
    html << "</ul></div>"
  end

  private
  def linker(url)
    "<div style=\"cursor:pointer;\" onclick=\"#{"window.opener.CKEDITOR.tools.callFunction(1, '#{url}" }'); window.close();\" >"
  end
end
