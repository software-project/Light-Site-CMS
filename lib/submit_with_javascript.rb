
module ActionView
  module Helpers
    module FormHelper
      def submit_with_javascript(object_name, method, text, options = {})
        "<a href=\"javascript: document.#{object_name}_#{options[:object].id}.submit();\">
          <div class=\"bt\">
            <div class=\"bt-green-l\"></div>
            <div class=\"bt-green-c\">#{method}</div>
            <div class=\"bt-green-arrow\"></div>
          </div>
        </a>"
      end
    end

    class FormBuilder
      def submit_with_javascript(method, text = nil, options = {})
        @template.submit_with_javascript(@object_name, method, text, objectify_options(options))
      end
    end
  end
end