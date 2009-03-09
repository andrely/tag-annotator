class CreateTaggedTexts < ActiveRecord::Migration
  def self.up
    create_table :tagged_texts do |t|
      t.string :filename

      t.timestamps
    end
  end

  def self.down
    drop_table :tagged_texts
  end
end
