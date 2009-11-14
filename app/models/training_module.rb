class TrainingModule < ActiveRecord::Base
  has_many :training_module_events, :dependent => :delete_all
  belongs_to :training

  def events_by_university
    training_module_events.group_by{|tmg| tmg.university}
  end
end
