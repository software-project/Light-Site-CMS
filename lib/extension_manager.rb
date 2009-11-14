module ExtensionManager
  @@extensions = Hash.new
  EXT_OPTIONS = %w{AjaxListExtension ListExtension AttributesExtension}

  class << self
    def map()
      @extensions ||= Hash.new
      mapper = Mapper.new(@extensions)
      if block_given?
        yield mapper
      else
        mapper
      end
    end

    def extensions
      @extensions ||= Hash.new
    end

    def render(options = {})
      html = ""
      isok = %w{ ant bear cat}.any? {|word| word.eql? "dupa"}
      exts = extensions.select{|k,i| i.position == options[:position] and i.actions.any?{|e| e.eql? options[:action]} and i.enable}
      EXT_OPTIONS.each{|option|
        tmp = exts.select{|i| i[1].ext_type.eql? option}
        if tmp.size > 0
          ext = ExtensionManager.const_get(option)
          html << ext.render_all(tmp.collect{|i| i[1]}, options)
        end
      }
      html
    end
  end

  class Mapper
    def initialize(items)
      items ||= Hash.new
      @extensions = items
    end

    @@last_extensions_count = Array.new

    def push(name, position, options = {})
      if @extensions[name].nil?
        extension = ExtensionManager.const_get(options[:type])
        @extensions[name] = extension.new(name, position, options)
      else
        raise "This extension already exists"
      end
    end

    # Removes a menu item
    def delete(ext_type, name)
      @extensions[ext_type].delete(name)
    end
  end

  class Extension
    attr_reader :name, :position, :actions, :ext_type, :options, :enable

    def initialize(name, position, tmp_options = {})
      @name = name
      @position = position
      @actions = tmp_options.delete(:actions)
      @ext_type = tmp_options.delete(:type)
      @options = tmp_options
      @enable = true
    end

    def render(options = {})
      raise "unimplemented method"
    end

    class << self
      def render_all(items, options)
        raise "unimplemented method"
      end
    end

  end

  class AjaxListExtension < ExtensionManager::Extension

    def initialize(name, position, options = {})
      super(name, position, options)
    end

    class << self
      def render_all(items, tmp_options)
        html = ""
        count = 0
        select_option = Hash.new
        divs = ""
        selector = ""
        items.each{|v|           
          select_option[count] = {:name => v.name, :value => v}
          divs << "<div id=\"ext_#{v.name}\" style=\"display: none;\">#{tmp_options[:view].render :partial => v.options[:partial], :locals => { :f => tmp_options[:form]}} </div>"
          if count == 0
            divs << "<script type=\"text/javascript\">$('##{tmp_options[:position]}_extensions').html($('#ext_#{v.name}').html()); </script>"
          end
          count += 1
        }
        if !tmp_options[:list_style].nil? and tmp_options[:list_style] <=> "select"
          html << "<select>"
          select_option.each{|k,v|
            selector << "<option value=\"k.to_s\" onclick=\"$(\"#extensions\").html = $(\"#ext_#{v["name"]};\">#{t(v["name"])}</option>"
          }
          html << selector
          html << "</select>"
        else
          html << "<ul id=\"ext_li_#{tmp_options[:position]}\">"
          select_option.each{|k,v|
            selector << "<li #{"style=\" background:gray;\"" if k.to_s.eql?("0")} id=\"ext_li_#{tmp_options[:position]}_#{k}\"><a onclick=\"$('##{tmp_options[:position]}_extensions').html($('#ext_#{v[:name]}').html()); $('#ext_li_#{tmp_options[:position]} > li ').css('background','none'); $('#ext_li_#{tmp_options[:position]}_#{k}').css('background','gray'); \">#{v[:name].to_s}</a></li>"
          }
          html << selector
          html << "</ul>"
        end
        html << "<div class=\"extensions\" id=\"#{tmp_options[:position]}_extensions\"></div>"
        html << divs
        html
      end
    end
  end

  class ListExtension < ExtensionManager::Extension
#    attr_reader :url
#    def initialize(name, class_name, position, options = {})
#      super(name, class_name, position, options = {})
#      @url =
#    end
    def render(options = {})
    end

     class << self
      def render_all(items, options)
#        raise "unimplemented method"
      end
     end
  end

  class AttributesExtension < ExtensionManager::Extension

    def initialize(name, position, options = {})
      super(name, position, options)
    end

    def render(tmp_options = {})
      tmp_options[:view].render :partial => options[:partial], :locals => { :f => tmp_options[:form]}
    end

    class << self
      def render_all(items, tmp_options)
        html = ""
        items.each{|v|
          html << v.render(tmp_options)
        }
        html
      end
    end
  end
end