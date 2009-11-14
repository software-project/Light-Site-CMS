class GalleryPhoto < ActiveRecord::Base
  belongs_to    :gallery
  has_attachment :content_type => :image,
                 :storage => :file_system,
                 :max_size => 3.megabytes,
                 :resize_to => '920x920>',
                 :thumbnails => { :thumb => 'x100>', :preview => 'x200>'}

#  validates_as_attachment

end
