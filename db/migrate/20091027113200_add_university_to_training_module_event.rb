class AddUniversityToTrainingModuleEvent < ActiveRecord::Migration
  def self.up
    add_column :training_module_events, :university, :string
  end

  def self.down
    remove_column :training_module_events, :university
  end
end
