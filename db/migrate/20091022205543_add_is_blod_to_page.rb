class AddIsBlodToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :is_blog, :boolean
  end

  def self.down
    remove_column :pages, :is_blog
  end
end
