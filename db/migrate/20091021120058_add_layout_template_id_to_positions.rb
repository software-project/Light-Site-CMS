class AddLayoutTemplateIdToPositions < ActiveRecord::Migration
  def self.up
    add_column :positions, :layout_template_id, :integer
    
    LayoutTemplate.create(:name => "application", :header_image => "main")
    Position.create(:name => "content", :main_position => true, :page_pagination => 0, :layout_template_id => 1)
    Position.create(:name => "side", :main_position => false, :page_pagination => 0, :layout_template_id => 1)
    Position.create(:name => "footer", :main_position => false, :page_pagination => 0, :layout_template_id => 1)
  end

  def self.down
    remove_column :positions, :layout_template_id
  end
end
