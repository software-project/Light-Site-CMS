class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.float :latitude, :precision => 10, :scale => 6
      t.float :logitude, :precision => 10, :scale => 6
      t.text :content

      t.timestamps
    end
    ExtensionType.create(:name => "Map", :controller_name => "locations")
  end

  def self.down
    drop_table :locations
  end
end
