class Status < ActiveRecord::Base
  has_many :pages
  has_many :items
  belongs_to :language
end
