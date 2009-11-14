class Page < ActiveRecord::Base

  validates_presence_of :layout_template_id
  validates_presence_of :language_id

  make_permalink :with => :slug

  has_many :children, :class_name => "Page", :foreign_key => :parent_id, :dependent => :delete_all, :order => "pages.order DESC"
  belongs_to :parent, :class_name => "Page", :foreign_key => :parent_id
  belongs_to :status
  has_many :blocks, :dependent => :delete_all
  has_many :positions, :through => :layout_template
  belongs_to :language
  belongs_to :layout_template


  def get_page_path
    if self.class.nil? || self.class == Page
    "/#{language.short_name.upcase}/#{slug}"
    else
      object = Object.const_get(self.class)
      object.get_page_path
    end
  end

  def lower_item(order_position)
    list = []
    self.children.each{|p|
      list << p if p.order < order_position
    }
    list.last
  end

  def higher_item(order_position)
    list = self.children.select{|p| p.order > order_position }.sort_by { |o| o.order  }
    list.first
  end

end
