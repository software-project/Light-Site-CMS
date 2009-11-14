
require "acts_as_commentable"
require "ckfinder"
require "extension_manager"

Ckfinder.map do |attachments|
  attachments.push "Attachment"
  attachments.push "GalleryPhoto"
end

ExtensionManager.map do |ext|
  ext.push("blog", "page", {:type => "AttributesExtension", :actions => ["new", "edit"], :partial => "/pages/blog_form"})
  ext.push("user_admin", "admin_panel", {:type => "AjaxListExtension", :actions => ["show"], :partial => "/users/admin"})
  ext.push("layouts", "admin_panel", {:type => "AjaxListExtension", :actions => ["show"], :partial => "/layout_templates/layouts"})
  ext.push("commentable", "plain_text", {:type => "AttributesExtension", :actions => ["show"], :partial => "/comments/comments"})
  ext.push("commentable_edit", "plain_text", {:type => "AttributesExtension", :actions => ["new","edit"], :partial => "/comments/commentable"})
  ext.push("general", "admin_panel", {:type => "AjaxListExtension", :actions => ["show"], :partial => "/shared/general_admin"})
end

