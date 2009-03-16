class CreateSentences < ActiveRecord::Migration
  def self.up
    create_table :sentences do |t|
      t.integer :text_index
      t.integer :text_id
      t.integer :length

      t.integer :tagged_text_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :sentences
  end
end
