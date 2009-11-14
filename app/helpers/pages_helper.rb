module PagesHelper
  def header_name(page)
    if !page.nil? && !page.layout_template.nil?
      page.layout_template.header_image
    else
      "main"
    end
  end

  def admin_on_off
    if session[:admin].nil? || session[:admin] == :on
      print "---------------its ok-#{}-----------------"
      true
    else
      false
    end
  end

  def post_class_name(counter, last)
    if counter%2 == 1
      if last
        "last"
      else
        "odd"
      end
    else
      "even"
    end
  end

  def visible_items(items)
    counter = 0
    items.each{|i|
      counter += 1 if i.status.name == "Visible"
    }
    counter
  end
end
