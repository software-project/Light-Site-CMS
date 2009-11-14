class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :block_id
      t.integer :user_id
      t.integer :status_id
      t.integer :order
      t.integer :connector
      t.integer :extension_type_id
      t.integer :resource_id
      t.string :resource_type

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
