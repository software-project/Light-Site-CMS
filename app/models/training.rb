class Training < ActiveRecord::Base
  has_many :training_modules, :dependent => :delete_all
  has_one :item, :as => :resource

  def modules_by_university(university)
    training_modules.find(:all, :include => :training_module_events, :conditions => ["training_module_events.university = ?", university])
  end

  def group_by_university
    training_modules.find(:all, :joins => :training_module_events, :select => "training_modules.*, training_module_events.university as university", :group => "training_module_events.university")    
  end
end
