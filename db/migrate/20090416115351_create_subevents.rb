class CreateSubevents < ActiveRecord::Migration
  def self.up
    create_table :subevents do |t|
      t.integer :event_id
      t.datetime :event_date
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :subevents
  end
end
