class CreateExtensionTypes < ActiveRecord::Migration
  def self.up
    create_table :extension_types do |t|
      t.string :name
      t.string :controller_name

      t.timestamps
    end
  end

  def self.down
    drop_table :extension_types
  end
end
