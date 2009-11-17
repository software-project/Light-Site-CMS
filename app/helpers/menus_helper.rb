module MenusHelper

  def menu_form_helper(page, depth)
    html = ""
    for tmpage in page.active_children
      html << "<li #{params[:name] == tmpage.slug ? " id=\"selected-page\"" : "" }><a href=\"#{tmpage.get_page_path}\">#{tmpage.name}</a>" if tmpage.status.id == 1
      if admin? && (session[:admin] == :on || session[:admin].nil?)
        html << "<li><a href=\"#{tmpage.get_page_path}\">#{tmpage.name}</a>" unless tmpage.status.id == 1
        html << page_admin(tmpage)
      end
      if depth > 0
        html << "<ul>#{menu_form_helper(tmpage, depth - 1)}</ul>" if tmpage.status.id == 1 || admin? && (session[:admin] == :on || session[:admin].nil?)
        html << "<ul>" + sub_menu_form_helper(tmpage) +"</ul>"
      end
      html << "</li>"
    end
    html
  end

  def menu_jquery(page, page_slug)

    html = ""
    page_slug = page_slug.slug unless page_slug.nil?
    if page_slug !=false && page_slug!=nil && page!=nil
    html << "<div id=\"menu-tabs\" class=\"ui-tabs ui-widget ui-widget-content ui-corner-all\">"
    html << "<ul class=\"ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all\">"
    for tmpage in page.children
      if tmpage.slug == page_slug
        html << "<li class=\"ui-state-default ui-corner-top ui-tabs-selected ui-state-active\"><a href=\"#{tmpage.get_page_path}\" >#{tmpage.name}</a>" if tmpage.status.id == 1
      else
        html << "<li class=\"ui-state-default ui-corner-top \"><a href=\"#{tmpage.get_page_path}\" >#{tmpage.name}</a>" if tmpage.status.id == 1
      end
      #      html << "<li><a href=\"www.wp.pl\">asdsda</a>"
      html << "</li>"

    end
    html << '</ul>'
    html << "<div class=\"ui-tabs-panel ui-widget-content ui-corner-bottom \">"
    else
      html << "<div id=\"tabs2\" class=\"ui-tabs ui-widget ui-widget-content ui-corner-all\">"
      html << "<div class=\"ui-tabs-panel ui-widget-content ui-corner-bottom \">"
    end
    html
  end

  def sub_menu_form_helper(root_page)
    items = root_page.blocks.select{|t| t.position_id = 1}.first.items
    html = ""
    #    basic_url = "<li><a#{params[:name] == item.slug ? " class=\"selected-page\"" : "" } href=\"#{root_page.get_page_path}"
    for item in items
      if item.resource.respond_to?('header')
        html << "<li#{ (item.respond_to?('slug') and params[:name] == item.slug) ? " id=\"selected-page\"" : "" }><a href=\"#{root_page.get_page_path}" + "\/\##{item.order}\">#{item.resource.header}</a></li>"
      end
    end
    html
  end

  def menu_form(root_page, menu_type, depth)
    unless root_page.nil?
      html = "<ul>"
      if menu_type < 4
        root_page = Page.find(:first, :conditions => ["language_id = ? and parent_id is null", root_page.language.id] )
        html << menu_form_helper(root_page, depth)
      else
        html << sub_menu_form_helper(root_page)
      end
      html << "</ul>"
    end
  end

  private
  def page_admin(page)
    html = ""
    html << "<ul class=\"admin-menu\" ><li>"
    html << "#{link_to image_tag("/images/admin/page_child_add.png", :title => t('admin.add subpage')), {:controller => :pages, :action =>  :new, :parent_id => page.id}}"
    html << "#{link_to image_tag("/images/admin/page_edit.png", :title => t('admin.page edit')), "/pages/#{page.id}/edit"}"
    html << "#{link_to image_tag("/images/admin/page_delete.png", :title => t('admin.page delete')), page, :confirm => t('are you sure?'), :method => :delete}"
    html << "#{link_to image_tag("/images/admin/move_up.png", :title => t('admin.move up')), "/pages/move_up/#{page.id}"}"
    html << "#{link_to image_tag("/images/admin/move_down.png", :title => t('admin.move down')), "/pages/move_down/#{page.id}"}"
    html << "</li></ul>"
    html
  end
end
