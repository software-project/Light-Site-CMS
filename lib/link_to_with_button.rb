module ActionView
  module Helpers
    module UrlHelper

#     Generates fancy button from given parameters
#     Example:
#       link_to_with_button {:button_color => "green", :image => "/images/image.png"}, "Link text", {:controller => "controller", :action => "action"} }
      def link_to_with_button(*args, &block)
        if block_given?
          button_options = args.first
          options      = args.second || {}
          html_options = args.third
          concat(link_to_with_button(capture(&block),button_options, options, html_options))
        else
          button_options = args.first
          name         = args.second
          options      = args.third || {}
          html_options = args.fourth
          if !button_options[:size].nil? and button_options[:size].eql? "small"
            link_to "<div class=\"bt\"><div class=\"bt-#{button_options[:button_color]}-small-#{button_options[:image]}\"></div></div>",
              options, html_options
          else
            link_to "<div class=\"bt\">
              <div class=\"bt-#{button_options[:button_color]}-l\"></div>
              <div class=\"bt-#{button_options[:button_color]}-c\">#{name}</div>
              <div class=\"bt-#{button_options[:button_color]}-#{button_options[:image]}\"></div>
              </div>",options, html_options
          end
        end
      end

      def link_to_remote_with_button(*args, &block)
        if block_given?
          button_options = args.first
          options      = args.second || {}
          html_options = args.third
          concat(link_to_with_button(capture(&block),button_options, options, html_options))
        else
          button_options = args.first
          name         = args.second
          options      = args.third || {}
          html_options = args.fourth
          if !button_options[:size].nil? and button_options[:size].eql? "small"
            link_to_remote "<div class=\"bt\"><div class=\"bt-#{button_options[:button_color]}-small-#{button_options[:image]}\"></div></div>",
              options, html_options
          else
            link_to_remote "<div class=\"bt\">
              <div class=\"bt-#{button_options[:button_color]}-l\"></div>
              <div class=\"bt-#{button_options[:button_color]}-c\">#{name}</div>
              <div class=\"bt-#{button_options[:button_color]}-#{button_options[:image]}\"></div>
              </div>",options, html_options
          end
        end
      end
    end
  end
end