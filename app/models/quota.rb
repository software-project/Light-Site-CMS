class Quota < ActiveRecord::Base
  has_one :item, :as => :resource
end
