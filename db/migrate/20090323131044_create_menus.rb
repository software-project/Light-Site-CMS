class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.integer :menu_type_id
      t.integer :depth

      t.timestamps
    end

    ExtensionType.create(:name => "Menu", :controller_name => "menus")
  end

  def self.down
    drop_table :menus
  end
end
