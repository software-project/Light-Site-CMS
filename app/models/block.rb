class Block < ActiveRecord::Base
  belongs_to :page
  belongs_to :position
  has_many :items, :order => "items.order DESC", :dependent => :destroy

  def lower_item(order_position)
    list = items.find_all{ |p| p.order < order_position }.sort_by { |o| o.order  }
    list.last
  end

  def higher_item(order_position)
    list = items.find_all{ |p| p.order > order_position }.sort_by { |o| o.order  }
    list.first
  end

end
