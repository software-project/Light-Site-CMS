class AddBlogAttributesToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :page_type, :string
    add_column :pages, :description, :text
    add_column :pages, :user_id, :integer
  end

  def self.down
    remove_column :pages, :page_type
    remove_column :pages, :description
    remove_column :pages, :user_id
  end
end
