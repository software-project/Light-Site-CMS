module ItemsHelper
  def post_min_height(item)
    max = 0
    max = item.resource.thumb_attachment.thumbnails.find(:first,:conditions => "thumbnail = \"thumb\"").height if item.resource.respond_to?(:thumb_attachment) && !item.resource.thumb_attachment.nil?
    if item.resource.respond_to?(:content) and !item.resource.content.nil?
      tmp_content = item.resource.content
      src = []
      while (tmp_content =~ /img|IMG/) != nil
        if tmp_content =~ /src="|SRC="/
          tmp_content = tmp_content[((tmp_content =~ /src="|SRC="/) + 5)..tmp_content.size]
          src += [tmp_content[0..tmp_content =~ /"/]]
        end
        tmp_content = tmp_content[tmp_content =~ /"/..tmp_content.size]
      end
      src.each { |i|
        a = i.split(/\//)
# TODO sprawdzanie wysokości zdjęcia
#        image = TinyMcePhoto.find_by_filename(a.last.chomp("\""))
#        max = image.height if image.height > max unless image.nil?
      }
    end
    max + 50
  end
end
