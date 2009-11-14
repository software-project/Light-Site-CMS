class AddPagePaginationToPosition < ActiveRecord::Migration
  def self.up
    add_column :positions, :page_pagination, :integer
    add_column :positions, :main_position, :boolean
  end

  def self.down
    remove_column :positions, :page_pagination
    remove_column :positions, :main_position
  end
end
