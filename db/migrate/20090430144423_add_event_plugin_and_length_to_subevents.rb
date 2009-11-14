class AddEventPluginAndLengthToSubevents < ActiveRecord::Migration
  def self.up
    add_column :subevents, :length, :integer
    add_column :subevents, :unit, :string
    ExtensionType.create(:name => "Event", :controller_name => "events")

  end

  def self.down
    remove_column :subevents, :length
    remove_column :subevents, :unit

  end
end
