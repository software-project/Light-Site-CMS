class CreateLayoutTemplates < ActiveRecord::Migration
  def self.up
    create_table :layout_templates do |t|
      t.string :name
      t.string :header_image

      t.timestamps
    end
  end

  def self.down
    drop_table :layout_templates
  end
end
