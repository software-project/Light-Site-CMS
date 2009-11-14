class CreateTrainings < ActiveRecord::Migration
  def self.up
    create_table :trainings do |t|
      t.string :header
      t.timestamps
    end
  end

  def self.down
    drop_table :trainings
  end
end
