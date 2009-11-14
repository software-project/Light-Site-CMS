class ExtensionType < ActiveRecord::Base
  has_many :items
  belongs_to :language
end
