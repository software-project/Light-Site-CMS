class Position < ActiveRecord::Base
  has_many :blocks, :dependent => :destroy
  belongs_to :layout_template

  def validate
    if !page_pagination.nil? && page_pagination < 0
      errors.add(:page_pagination, I18n.translate("activerecord.errors.messages.greater_than_or_equal_to" , :count => 0) )
    end
  end
end
