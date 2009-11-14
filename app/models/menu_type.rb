class MenuType < ActiveRecord::Base
  has_many :menus
  belongs_to :language
end
