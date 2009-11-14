class CreateTrainingModuleEvents < ActiveRecord::Migration
  def self.up
    create_table :training_module_events do |t|
      t.integer :training_module_id
      t.text :place
      t.timestamp :event_date
      t.timestamps
    end
    ExtensionType.create(:name => "Training", :controller_name => "trainings")
  end

  def self.down
    drop_table :training_module_events
  end
end
