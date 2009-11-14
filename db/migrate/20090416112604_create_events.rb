class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :header
      t.text :content
      t.date :start_date
      t.date :end_date
      t.integer :char_showed

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
