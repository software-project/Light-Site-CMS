class Item < ActiveRecord::Base
  acts_as_taggable
  
  belongs_to :extension_type
  belongs_to :block
  belongs_to :user
  belongs_to :status
  belongs_to :resource, :polymorphic => true, :dependent => :delete

end
