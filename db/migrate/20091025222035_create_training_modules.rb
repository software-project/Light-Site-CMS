class CreateTrainingModules < ActiveRecord::Migration
  def self.up
    create_table :training_modules do |t|
      t.string :name
      t.text :content
      t.integer :training_id

      t.timestamps
    end
  end

  def self.down
    drop_table :training_modules
  end
end
