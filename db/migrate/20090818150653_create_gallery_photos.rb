class CreateGalleryPhotos < ActiveRecord::Migration
  def self.up
    create_table :gallery_photos do |t|
      t.integer :gallery_id
      t.column :parent_id,  :integer
      t.column :content_type, :string
      t.column :filename, :string
      t.column :thumbnail, :string 
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.column :description, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :gallery_photos
  end
end
