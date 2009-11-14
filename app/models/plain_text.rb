class PlainText < ActiveRecord::Base 
  has_one :item, :as => :resource
  belongs_to :thumb_attachment, :class_name => "Attachment", :foreign_key => :thumb_attachment_id
  belongs_to :background_attachment, :class_name => "Attachment", :foreign_key => :background_attachment_id
  has_many :attachments
  acts_as_taggable
  acts_as_commentable
 
  def self.search(search, page)
    str = "\'%"
    search.scan(/\w+/).each { |i|
      str << i+" % "
      }
      str = str.slice(0, str.size - 3)
      str << "%\'"
    paginate :per_page => 1, :page => page,
      :conditions => "content like #{str} or header like #{str}", :order => 'header'
  end

end
