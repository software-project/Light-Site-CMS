class Gallery < ActiveRecord::Base
  has_many :gallery_photos
  has_one :item, :as => :resource
end
