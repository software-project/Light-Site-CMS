class AddNameToGalleryPhoto < ActiveRecord::Migration
  def self.up
    add_column :gallery_photos, :name, :string
  end

  def self.down
    remove_column :gallery_photos, :name
  end
end
