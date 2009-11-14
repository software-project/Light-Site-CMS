module LanguagesHelper
  def unconnected_languages(connector)
    @pages = Page.find_all_by_connector(connector)
    all_languages = Language.find(:all)
    for page in @pages
      all_languages = all_languages - [page.language]
    end
    all_languages
  end

  def language_linker(page)
    html = ""
    languages = Language.find(:all)
    for language in languages
      newpage = Page.find_by_connector(page.connector, :conditions => ["language_id = ?", language.id])
      if newpage.nil?
        newpage = Page.find_by_parent_id(nil,:conditions => ["language_id = ?", language.id])
      end
      unless newpage.nil?
        html << "<a href=\"#{newpage.get_page_path}\">#{image_tag("/images/flags/" + language.short_name + ".png")}</a>"
      end
    end
    html
  end
end
