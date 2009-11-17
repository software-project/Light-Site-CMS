class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.string :name
      t.string :short_name

      t.timestamps
    end

    Language.create(:name => "Polski", :short_name => "pl")
    Language.create(:name => "English", :short_name => "en")
    Language.create(:name => "Deutsch", :short_name => "de")
  end

  def self.down
    drop_table :languages
  end
end
