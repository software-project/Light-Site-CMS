class LayoutTemplate < ActiveRecord::Base
  has_many :pages
  has_many :positions

  def name_with_image
    "#{name}-#{header_image}"
  end

  def main_position
    positions.find(:first, :conditions => ["main_position = 1"])
  end
end
