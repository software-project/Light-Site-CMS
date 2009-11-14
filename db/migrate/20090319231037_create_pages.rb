class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :name
      t.integer :language_id
      t.integer :parent_id
      t.integer :status_id
      t.integer :connector
      t.string :slug
      t.integer :layout_template_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
