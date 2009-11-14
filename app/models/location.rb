class Location < ActiveRecord::Base
  has_one :item, :as => :resource
end
