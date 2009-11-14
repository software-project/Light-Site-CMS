class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.string :name
      t.string :short_name

      t.timestamps
    end

    Language.create(:name => "Polski", :short_name => "PL")
    Language.create(:name => "English", :short_name => "EN")
    Language.create(:name => "Deutsch", :short_name => "DE")
  end

  def self.down
    drop_table :languages
  end
end
