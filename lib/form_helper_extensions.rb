
module ActionView
  module Helpers
    module FormHelper
      def spinbox_field(object_name, method, options = {})
#         min_val = options.delete(:min)
#         max_val = options.delete(:max)
#         tag = InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("text", options.merge({:class =>"spin-button"}))
#         script = "<script type=\"text/javascript\">
#            var myOptions = {
#              #{"min:#{min_val}" if min_val}
#              #{"," if min_val and max_val}
#              #{"max:#{max_val}" if max_val}
#            };
#        $(document).ready(function(){
#          $(\"##{object_name}_#{method}\").SpinButton(myOptions);
#
#        }); </script>"
#         tag+script
        html = options.delete(:html)
        tag = InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("text",html)
        script = "<script type=\"text/javascript\">
            $(document).ready(function(){"
        spin_options = ""
        counter = 1
        options.each{|k,v|
          spin_options << "#{k.to_s}: #{v}"
          spin_options << "," if options.size > counter
          counter += 1
        }
        script << "$('##{object_name}_#{method}').spin({#{spin_options}});"
        script << "});</script>"
        tag+script
      end

      def ckeditor_field(object_name, method, options = {})
        script =""
          "<script type=\"text/javascript\">
            if(editor)
              return;
            editor = CKEDITOR.replace( '#{object_name}_#{method}', {
                    filebrowserBrowseUrl : '/browser/get_folders',
                    filebrowserUploadUrl : '/browser/quick_upload',
                    filebrowserImageWindowWidth : '640',
                    filebrowserImageWindowHeight : '480'
            });
          </script>"

#             editor.setData( html );
#          </script>"
#          html = "<div id=\"editor_#{object_name}\"></div><div id=\"editorcontents_#{object_name}\"/>"
#          html+script
          tag = InstanceTag.new(object_name, method, self, options.delete(:object)).to_text_area_tag(options)
         tag+script
      end

    end

    class FormBuilder
      def spinbox_field(method, options = {})
        @template.spinbox_field(@object_name, method, options)
      end

      def ckeditor_field(method, options = {})
#        @template.ckeditor_field(@object_name, method, options)
        script ="
          <script type=\"text/javascript\">
            
            editor = CKEDITOR.replace( '#{object_name}_#{method}', {
                    filebrowserBrowseUrl : '/browser/get_folders',
                    filebrowserUploadUrl : '/browser/quick_upload',
                    filebrowserImageWindowWidth : '640',
                    filebrowserImageWindowHeight : '480'
            });
          </script>"
        i = @object.method(method)
        value = i.call
        text = @template.text_area(@object_name, method, options.merge(:value => value))
        text+script
      end
    end
  end
end
