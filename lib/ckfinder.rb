module Ckfinder

  @@items = Array.new
  
  class << self
    def map()
      @items ||= []
      mapper = Mapper.new(@items)
      if block_given?
        yield mapper
      else
        mapper
      end
    end

    def items
      @items || []
    end
  end

  module CkfinderHelper

    def get_all_items
      groups = {}
      Ckfinder.items.each { |i|
        groups[i]= get_items_by_group(i)
      }
      groups
    end

    def get_items_by_group(group)
      item = Object.const_get(group)
      items = item.find(:all, :conditions => ["parent_id is null"])
      items_options(items, item)
    end

    def items_options(items, item_object)
      array = {}
      items.each{|i|
        array[i.filename]= {:item =>  i, :children => [item_object.find(:all, :conditions => ["parent_id = ?",i.id])]}
      }
      array
    end
  end

  class Mapper
    def initialize(items)
      items ||= []
      @photos = items
    end

    @@last_items_count = Array.new

    def push(name)
      @photos << name
    end

    # Removes a menu item
    def delete(name)
      @photos.delete_if {|i| i.name == name}
    end
  end
end