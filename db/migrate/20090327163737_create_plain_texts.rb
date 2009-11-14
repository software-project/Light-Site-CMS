class CreatePlainTexts < ActiveRecord::Migration
  def self.up
    create_table :plain_texts do |t|
      t.string :header
      t.text :content
      t.integer :showed_signs_on_preview
      t.boolean :post

      t.timestamps
    end
    ExtensionType.create(:name => "Text", :controller_name => "plain_texts")
  end

  def self.down
    drop_table :plain_texts
  end
end
