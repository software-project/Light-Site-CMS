class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :subject
      t.text :content
      t.integer :status_id
      t.integer :user_id
      t.string :user_name
      t.integer :commentable_id
      t.string :commentable_type
      t.integer :parent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
