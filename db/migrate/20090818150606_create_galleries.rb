class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.string :name
      t.timestamps
    end
    ExtensionType.create(:name => "Gallery", :controller_name => "galleries")
  end

  def self.down
    drop_table :galleries
  end
end
