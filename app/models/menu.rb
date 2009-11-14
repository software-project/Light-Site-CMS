class Menu < ActiveRecord::Base
  belongs_to :menu_type
  has_one :item, :as => :resource
end
