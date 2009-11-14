class CreateBlocks < ActiveRecord::Migration
  def self.up
    create_table :blocks do |t|
      t.integer :page_id
      t.integer :position_id

      t.timestamps
    end
  end

  def self.down
    drop_table :blocks
  end
end
