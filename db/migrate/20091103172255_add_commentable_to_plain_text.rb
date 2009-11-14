class AddCommentableToPlainText < ActiveRecord::Migration
  def self.up
    add_column :plain_texts, :commentable, :boolean
  end

  def self.down
    remove_column :plain_texts, :commentable
  end
end
