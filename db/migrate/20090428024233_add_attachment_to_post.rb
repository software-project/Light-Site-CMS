class AddAttachmentToPost < ActiveRecord::Migration
  def self.up
    add_column :plain_texts, :thumb_attachment_id, :integer
    add_column :plain_texts, :background_attachment_id, :integer
  end

  def self.down
    remove_column :plain_texts, :thumb_attachment_id
    remove_column :plain_texts, :background_attachment_id
  end
end
