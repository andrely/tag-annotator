class CreateWords < ActiveRecord::Migration
  def self.up
    create_table :words do |t|
      t.string :string
      t.integer :sentence_index
      t.integer :sentence_id
      t.integer :tag_count

      t.timestamps
    end
  end

  def self.down
    drop_table :words
  end
end
