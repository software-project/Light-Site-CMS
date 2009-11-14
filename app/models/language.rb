class Language < ActiveRecord::Base
  has_many :items
  has_many :extension_types
  has_many :pages
  has_many :menu_types
end
