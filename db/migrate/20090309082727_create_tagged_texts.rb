class CreateTaggedTexts < ActiveRecord::Migration
  def self.up
    create_table :tagged_texts do |t|
      t.string :filename
      t.string :content_type
      t.binary :filedata, :limit => 20.megabyte
      t.integer :sentence_count

      t.timestamps
    end
  end

  def self.down
    drop_table :tagged_texts
  end
end
