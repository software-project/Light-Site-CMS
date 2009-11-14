class Attachment < ActiveRecord::Base

  has_one :item, :as => :resource

  has_attachment  :storage => :file_system,
                :content_type => [:image, 'application/x-shockwave-flash', 'application/jpg', 'application/doc', 'application/pdf'],
                :max_size => 5.megabytes,
                :resize_to => '600x>',
                :thumbnails => {:thumb => "200>", :medium => "290x320>", :large => "650 "},
                :processor => :MiniMagick,
                :path_prefix => 'public/attachments'
  has_many :plain_texts
  belongs_to :plain_text
  
end
