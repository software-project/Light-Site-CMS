module AttachmentsHelper
  def get_icon(filename)
    case filename[filename.size-3..filename.size]
    when "pdf" then image_tag("/images/mime-types/icon-pdf.png")
    when "doc" then image_tag("/images/mime-types/icon-doc.png")
    when "ppt" then image_tag("/images/mime-types/icon-ppt.png")
    else image_tag("/images/mime-types/icon-xxx.png")
    end
  end
end
