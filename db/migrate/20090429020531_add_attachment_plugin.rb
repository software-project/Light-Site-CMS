class AddAttachmentPlugin < ActiveRecord::Migration
  def self.up
    ExtensionType.create(:name => "Attachment", :controller_name => "attachments")
  end

  def self.down
  end
end
