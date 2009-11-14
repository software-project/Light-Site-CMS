class Event < ActiveRecord::Base
  has_one :item, :as => :resource
  has_many :subevents
end
