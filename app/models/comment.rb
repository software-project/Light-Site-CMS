class Comment < ActiveRecord::Base
  has_many :children, :class_name => "Comment", :foreign_key => :parent_id, :dependent => :delete_all
  belongs_to :parent, :class_name => "Comment", :foreign_key => :parent_id

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  def get_user
    if !user_name.nil?
      self.user_name
    else
      self.user.login      
    end
  end

end
