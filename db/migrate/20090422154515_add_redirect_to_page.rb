class AddRedirectToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :redirect, :integer
    add_column :pages, :order, :integer
  end

  def self.down
    remove_column :pages, :redirect
    remove_column :pages, :order
  end
end
