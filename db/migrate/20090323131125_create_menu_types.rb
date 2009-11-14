class CreateMenuTypes < ActiveRecord::Migration
  def self.up
    create_table :menu_types do |t|
      t.string :name
      t.integer :type_no

      t.timestamps
    end

    MenuType.create(:name => "Horizontal main menu", :type_no => '1')
    MenuType.create(:name => "Vertical main menu", :type_no => '2')
    MenuType.create(:name => "Vertical main menu with children", :type_no => '3')
    MenuType.create(:name => "Childrens menu", :type_no => '4')

  end

  def self.down
    drop_table :menu_types
  end
end
