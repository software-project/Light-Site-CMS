class AddPlainTextIdToAttachment < ActiveRecord::Migration
  def self.up
    add_column :attachments, :plain_text_id, :integer
  end

  def self.down
    remove_column :attachments, :plain_text_id
  end
end
